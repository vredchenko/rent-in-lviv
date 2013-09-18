_                   = require 'underscore' 
moment              = require 'moment'
casper              = require('casper').create(
    verbose:    true
    #logLevel:   "debug"
)
RentalProperty      = require './rental-property'
currentRegion       = null
startUrl            = 'http://vashmagazin.ua/cat/catalog/?rub=128'
visitedUrls         = []
pendingUrls         = []



# @NOTES
# @todo  time the whole thing
# @todo  work with FS
# @todo  investigate Spooky.js for running Casper from inside nodejs
# @todo  write a test suite ensuring markup we rely on has not changed



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


# param passed in is a string of messy string of html that we now need to parse
# to get our precious data out. This is also the most vulnerable part of the scraper
# sensitive to minor changes in the page's layout
#  
parseContentListingHTML = (html)->
    # divider class is 'r_top_r'
    el              = document.createElement('tbody')
    el.innerHTML    = html
    i               = 0
    listing         = []
    data            = new RentalProperty
    data.setRegion  currentRegion 

    for row in el.children
        
        if ( row.className isnt 'r_top_r' and row.className isnt 'border_bo' )
            tds = row.children
            for td in tds
                if ( td.className isnt 'td.right_border_table' ) # this td has no useful info
                    
                    if ( td.querySelectorAll( 'span.photocount' ).length ) # get photos
                        data.setNumImages parseInt ( td.querySelectorAll( 'span.photocount' )[0].textContent ) 
                        # @todo find a way to extract the images themselves

                    else # default case - extract text content
                        data.addRemark td.textContent.replace('&nbsp;', '')
        
        else if ( row.className is 'r_top_r' ) # start next data record
            listing.push data.getData()
            data = new RentalProperty
            data.setRegion currentRegion 
            i++

    console.log listing

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

            # add pages 2 - last to pendingUrls stack
            if ( currentPage == '1' ) 
                lastPage = @evaluate getLastPage
                links = ( url+'&page='+num for num in [2..lastPage] ) 
                pendingUrls = pendingUrls.concat links    

            @click 'span#detail_all' # click button to unfold all detailed info
            htmlContent = @getHTML 'table.ogolosh-avto-sp tbody'
            rawData     = parseContentListingHTML( htmlContent )
            # console.log rawData

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
