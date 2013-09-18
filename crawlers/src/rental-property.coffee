

class RentalProperty

    data: 
        address:            null
        region:             null
        rooms:              null
        price:
            uah:            null
            usd:            null
            euro:           null
        comments:           null
        images:             []
        nImages:            null
        contacts:           []
        additionalRemarks:  []


    constructor: ->

    generateHash: ->
        # generate an md5 hash based on all data to create a UID

    getData: ->
        @data
    
    # setters. @todo refactor to the point of elegance
    # 
    setRegion: (value)->
        @data.region = value

    setNumImages: (value)->
        @data.nImages = value

    addRemark: (value)->
        @data.additionalRemarks.push( value )



module.exports = RentalProperty