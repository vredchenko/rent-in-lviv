var request = require("request");
var cheerio = require("cheerio");
var js2xmlparser = require("js2xmlparser");
var easyXML = require('../node_modules/easyxml/index.js');
var  fs = require('fs');
//var  ht = require('ht');
var dumpToPath = "./data/" + (new Date().getTime()) + "vm.xml";
var   dumpBuffer = "";
    // console.log("tbody found");
request('http://vashmagazin.ua/cat/catalog/?rub=128&subrub=1', function (error, response, html) {
    //  console.log("tbody found3");
  if (!error && response.statusCode == 200) {
    var $ = cheerio.load(html);
    var parsedResults = []; 
var a = $('body').children().children().children().next().next().next().children().next().children().children().next().next();

//var a = $('table.ogolosh-avto-sp tbody')
console.log(a);

    // $('td.tr_det_15482').each(function(index,item){
    $('body').each(function(i, element){
      // Select the previous element
    // var a = $(this).children().children().children().children().children().children();
     // var title = a.text();
     // var title0 = a.contents();
      // var title2 = $(title0).eq(0).text();
      //   var title4 = $(this).children('.songTitle');
      // var title3 = $(title4).eq(0).text();
      // var url = a.attr("href") || "";
     //console.log(a);
     //  console.log(title);
    //    console.log(title0);
        //    var metadata = {
       
     //  "title": title//,
     //   "title2": title2,
     // "url":url,
     //    "title3": title3

    //  };
   //  //  console.log(js2xmlparser("root1", metadata));
      // Push meta-data into parsedResults array
    //  parsedResults.push(metadata);
    });
    // Log our finished parse results in the terminal
 dumpBuffer +=a;
    // dumpBuffer +=easyXML.render(parsedResults);
   // dumpBuffer +=js2xmlparser("root1", parsedResults,include=0 ) ;
  //  dumpBuffer=dumpBuffer.substring(dumpBuffer.search("<root1>"),999999999)
    //dumpBuffer="<root>"+dumpBuffer+"</root>"
   // dumpBuffer=dumpBuffer.replace('<?xml version="1.0" encoding="UTF-8" ?>',"")
   //console.log(dumpBuffer);
   // console.log(easyXML.render(parsedResults));
   // console.log(parsedResults);
fs.writeFile(dumpToPath, dumpBuffer);

    //return this.echo("Done.").exit();
 }
});