_                   = require 'underscore' 
moment              = require 'moment'
casper              = require('casper').create(
    verbose:    true
    #logLevel:   "debug"
)
startUrl            = 'http://vashmagazin.ua/cat/catalog/?rub=128'
visitedUrls         = []
pendingUrls         = []
pagelessUrl         = '' # used inside getSubCategoryPageUrls function


# @todo  time the whole thing
# @todo  work with FS
# @todo  add a grunt file for watching coffee errors
# @todo  investigate Spooky.js for running Casper from with nodejs

getSubCategories = -> # get subcategories from the landing page
    links = document.querySelectorAll "a.chapter_rub"
    Array::map.call links, (e)-> 
        # @todo exclude "Popyt" using synonyms pattern
        e.getAttribute( "href" ).replace( "../", "http://vashmagazin.ua/" )

getListingRegion = ->
    links = document.querySelectorAll "a.leftmenu_subrub_a"
    links[0].textContent

getCurrentPage = ->
    links = document.querySelectorAll "div.page.current a"
    links[0].textContent

getLastPage = ->
    pageLinks = document.querySelectorAll "div.page a" 
    links = Array::map.call pageLinks, (e)-> 
        e.textContent
    links.pop() # gets rid of "next page" link
    lastPage = parseInt links.pop()
    
    
# function called recursively during crawl
# 
spider = (url)->
    visitedUrls.push url
    
    casper.open( url ).then ->
        
        # print what ya doing!
        foreground = switch this.status().currentHTTPStatus
            when 200 then 'green'
            when 404 then 'red'
            else          'magenta'
        statusStyle =
            fg:     foreground
            bold:   true
        @echo ( @colorizer.format(this.status().currentHTTPStatus, statusStyle) + ' ' + url )



        # if root page
        if ( url == startUrl ) # gather sub-categories
            links = @evaluate getSubCategories
            # @todo when synonyms in place remove this hard-code:
            links.pop()
            pendingUrls = pendingUrls.concat links
        
        else # it's a listing page
            currentRegion = @evaluate getListingRegion
            currentPage   = @evaluate getCurrentPage
            
            if ( currentPage == '1' ) # add pages 2 - last to pendingUrls stack
                lastPage = @evaluate getLastPage
                links = ( url+'&page='+num for num in [2..lastPage] ) 
                pendingUrls = pendingUrls.concat links    

            # @todo continue here!
            @echo "@todo: time to scrape content!"
            
        # recurse in
        if ( pendingUrls.length > 0 )
            nextUrl = pendingUrls.shift()
            spider( nextUrl )


# Start spidering
casper.start startUrl, ->
    spider startUrl

# Start the run
casper.run ->
    @echo("Done.").exit()
