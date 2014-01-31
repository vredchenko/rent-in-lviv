var request = require("request");
var cheerio = require("cheerio");
var js2xmlparser = require("js2xmlparser");
var easyXML = require('../node_modules/easyxml/index.js');
var  fs = require('fs');
var dumpToPath = "./data/" + (new Date().getTime()) + "rr.xml";
var   dumpBuffer = "";

request('http://www.radioroks.com.ua/playlist/27-07-2011.html', function (error, response, html) {
  if (!error && response.statusCode == 200) {
    var $ = cheerio.load(html);
    var parsedResults = []; 
    $('div.song-list').each(function(i, element){
      // Select the previous element
      var a = $(this).children().children();
      var title = a.text();
      var title0 = $(this).children('.songTime');
      var title2 = $(title0).eq(0).text();
        var title4 = $(this).children('.songTitle');
      var title3 = $(title4).eq(0).text();
      var url = a.attr("href") || "";
    
      console.log(a);

      var metadata = {
        "title": title,
        "title2": title2,
        "url":url,
        "title3": title3
      };
      // console.log(js2xmlparser("root1", metadata));
      // Push meta-data into parsedResults array
      parsedResults.push(metadata);
    });
    
    // Log our finished parse results in the terminal
    dumpBuffer +=parsedResults;
    // dumpBuffer +=easyXML.render(parsedResults);
    dumpBuffer +=js2xmlparser("root1", parsedResults,include=0 ) ;
    dumpBuffer=dumpBuffer.substring(dumpBuffer.search("<root1>"),999999999) ;
    dumpBuffer="<root>"+dumpBuffer+"</root>" ;
    // dumpBuffer=dumpBuffer.replace('<?xml version="1.0" encoding="UTF-8" ?>',"")
    //console.log(dumpBuffer);
    // console.log(easyXML.render(parsedResults));
    //console.log(parsedResults);
    fs.writeFile(dumpToPath, dumpBuffer);

    //return this.echo("Done.").exit();
  }
});