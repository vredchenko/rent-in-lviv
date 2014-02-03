
var request = require("request");
var cheerio = require("cheerio");
var js2xmlparser = require("js2xmlparser");
var easyXML = require('../node_modules/easyxml/index.js');
var  fs = require('fs');
var   dumpBuffer = "";
// var parsedResults = []; 
function padStr(i) {    return (i < 10) ? "0" + i : "" + i;}
var today = new Date();
var temp = new Date();
temp.setDate(today.getDate()-1);
console.log(temp);   

    var dateStr = padStr(temp.getFullYear()) +"-"+
                  padStr(1 + temp.getMonth()) +"-"+
                  padStr(temp.getDate()) +"_"+
                  padStr(temp.getHours()) +"_"+
                  padStr(temp.getMinutes()) +"_"+
                  padStr(temp.getSeconds());
//var dumpToPath = "./data/" + dateStr+ "rr.xml";

var   dumpBuffer = "";

var now = new Date(Date.now());
//    var dumpToPath = "./data/" +  datepar+ "rr.xml"
// fs.writeFile(dumpToPath, dumpBuffer);
for (var d = new Date(2014, 0, 1); d <= now; d.setDate(d.getDate() + 1)) {

var datepar=padStr(d.getDate()) +"-"+padStr(1 + d.getMonth()) +"-"+padStr(d.getFullYear());
var url1='http://www.radioroks.com.ua/playlist/'+datepar+'.html';

console.log("before"+url1);
request(url1, function (error, response, html) {
      console.log("after"+url1);
  if (!error && response.statusCode == 200) {
    var $ = cheerio.load(html,{ normalizeWhitespace: true});
    var parsedResults = []; 
    $('div.song-list').each(function(i, element){
      var a = $(this).children().children();
      var title = a.text();
      var title0 = $(this).children('.songTime');
      var title2 = $(title0).eq(0).text();
        var categ = $(this).children('.songTitle').contents().eq(0).text();
      var songtitle = $(this).children('.songTitle').contents().eq(2).text();
      var url = a.attr("href") || "";
            var metadata = {
       "date":datepar,
       "time": title2,
       "artist": title,
     "url":url,
        "songtitle": songtitle,
        "categ":categ      };
       // Push meta-data into parsedResults array
      parsedResults.push(metadata);
    });
    // Log our finished parse results in the terminal
     dumpBuffer +=parsedResults;
     dumpBuffer +=js2xmlparser("root1", parsedResults,include=0 ) ;
    // dumpBuffer +=easyXML.render(parsedResults);
    dumpBuffer=dumpBuffer.substring(dumpBuffer.search("<root1>"),999999999)
    dumpBuffer="<root>"+dumpBuffer+"</root>"
      var dumpToPath = "./data/" +  datepar+ "rr.xml"
        console.log(dumpToPath);
fs.appendFile(dumpToPath, dumpBuffer, function (err) {});

         

  }
});

};