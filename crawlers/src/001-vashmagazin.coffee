_                   = require 'underscore' 
moment              = require 'moment'
easyXML             = require '../node_modules/easyxml/index.js'
casper              = require('casper').create(
    verbose:    true
    #logLevel:   "debug"
)
# util                = require 'util'
RentalProperty      = require './rental-property'
currentRegion       = null
startUrl            = 'http://vashmagazin.ua/cat/catalog/?rub=128'
visitedUrls         = []
pendingUrls         = []



# @NOTES
# @todo  time the whole thing
# @todo  save to FS
# @todo  investigate Spooky.js for running Casper from inside nodejs
# @todo  write a test suite ensuring markup we rely on has not changed
# @todo  better jshinting with https://github.com/sindresorhus/jshint-stylish



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
    i               = 0 # entry counter
    j               = 0 # tr counter
    listing         = []
    data            = new RentalProperty
    data.setRegion  currentRegion 

    for row in el.children
        
        if ( row.className isnt 'r_top_r' and row.className isnt 'border_bo' )
            tds = row.children
            for td, k in tds
                if ( td.className isnt 'td.right_border_table' ) # this td has no useful info
                    
                    if ( td.querySelectorAll( 'span.photocount' ).length ) # get photos
                        data.setNumImages parseInt ( td.querySelectorAll( 'span.photocount' )[0].textContent ) 
                        # @todo find a way to extract the images themselves

                    else # default case - extract text content
                        data.addRemark td.textContent.replace('&nbsp;', '')

                # if ( j is 0 and k is 0 ) this is where the images live, combine with @todo above

                if ( j is 0 and k is 1 ) # this row could hold the address line
                    data.setAddress td.textContent.replace('&nbsp;', '')

                if ( j is 1 and k is 0 ) # num of rooms and wall metrial
                    data.setNumRooms td.textContent.replace('&nbsp;', '') # @todo clean up text formatting

                if ( j is 1 and k is 1 ) # this gives data in the form "floor/total floors" 
                    data.setFloor td.textContent.replace('&nbsp;', '') 

                if ( j is 1 and k is 2 ) # property area (in square m)
                    data.setArea td.textContent.replace('&nbsp;', '')

                if ( j is 1 and k is 3 ) # prices
                    containers = td.querySelectorAll "nobr"
                    data.setPriceUAH containers[0].textContent.replace(' ', '')
                    data.setPriceUSD containers[1].textContent.replace(' ', '').replace('$', '')
                    # @note there's also a price per square meter in USD available from containers[2] node

                if ( j is 2 and k is 0 ) # contact info 
                    containers = td.querySelectorAll "nobr, a"
                    for c in containers # @note: more complicated logic can extract agency info
                        data.addContact( c.textContent )

                if ( j is 3 and k is 0 ) # additional remarks
                    data.addRemark td.textContent.replace('&nbsp;', '') # need to sanitize string

            j++
        
        else if ( row.className is 'r_top_r' ) # start next data record
            # console.log JSON.stringify( data.getData(), null, 2 )
            console.log "here"
            @temp = easyXML.render( data.getData() )
            console.log "there"

            listing.push data.getData()
            data = new RentalProperty
            data.setRegion currentRegion 
            i++
            j = 0

    listing



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
            listing     = parseContentListingHTML( htmlContent )
            
            console.log "number of data items on pageLinks: " + listing.length

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
