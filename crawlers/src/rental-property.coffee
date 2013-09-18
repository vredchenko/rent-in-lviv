

class RentalProperty

    @data = 
        address:        null
        rooms:          null
        price:
            uah:        null
            usd:        null
            euro:       null
        comments:       null
        images:         []
        contacts:       []

    constructor: ->

    generateHash: ->
        # generate an md5 hash based on all data to create a UID

    getData: ->
        @data