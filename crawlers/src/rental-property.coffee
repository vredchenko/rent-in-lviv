

class RentalProperty

    constructor: ->
        @data = 
            address:            null
            region:             null
            nRooms:             null
            floor:              null
            area:               null
            price:
                uah:            null
                usd:            null
                euro:           null
            comments:           null
            images:             []
            nImages:            null
            contacts:           []
            additionalRemarks:  []
        
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

    addContact: (value)->
        @data.contacts.push( value )

    setAddress: (value)->
        @data.address = value

    setNumRooms: (value)->
        @data.nRooms = value

    setFloor: (value)->
        @data.floor = value

    setArea: (value)->
        @data.area = value

    setPriceUAH: (value)->
        @data.price.uah = value

    setPriceUSD: (value)->
        @data.price.usd = value

    setPriceEURO: (value)->
        @data.price.euro = value


module.exports = RentalProperty