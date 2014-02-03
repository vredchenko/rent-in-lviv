function roks(dd){
var request = require("request");
var cheerio = require("cheerio");
var js2xmlparser = require("js2xmlparser");
var easyXML = require('../node_modules/easyxml/index.js');
var  fs = require('fs');

function padStr(i) {    return (i < 10) ? "0" + i : "" + i;}
var today = new Date();
var temp = new Date(dd);
//temp.setDate(today.getDate(dd));
console.log(temp);   
    //var temp= temp.setTime(temp.getTime() - (24*60*60*1000) );
    var dateStr = padStr(temp.getFullYear()) +"-"+
                  padStr(1 + temp.getMonth()) +"-"+
                  padStr(temp.getDate()) ;
var dumpToPath = "./data/" + dateStr+ "rr.xml";
var   dumpBuffer = "";
var datepar=padStr(temp.getDate()) +"-"+padStr(1 + temp.getMonth()) +"-"+padStr(temp.getFullYear());
request('http://www.radioroks.com.ua/playlist/'+datepar+'.html', function (error, response, html) {
  if (!error && response.statusCode == 200) {
    var $ = cheerio.load(html,{ normalizeWhitespace: true});
    var parsedResults = []; 
    $('div.song-list').each(function(i, element){
      // Select the previous element
      var a = $(this).children().children();
      var title = a.text();
      var title0 = $(this).children('.songTime');
      var title2 = $(title0).eq(0).text();
        var categ = $(this).children('.songTitle').contents().eq(0).text();
      var songtitle = $(this).children('.songTitle').contents().eq(2).text();
      var url = a.attr("href") || "";
       //console.log($(this));
       //.children().children().children().next()
            var metadata = {
       "date":datepar,
       "time": title2,
       "artist": title,
     "url":url,
        "songtitle": songtitle,
        "categ":categ
 
      };
      // Push meta-data into parsedResults array
      parsedResults.push(metadata);
    });
    // Log our finished parse results in the terminal
 dumpBuffer +=parsedResults;
    // dumpBuffer +=easyXML.render(parsedResults);
    dumpBuffer +=js2xmlparser("root1", parsedResults,include=0 ) ;
    dumpBuffer=dumpBuffer.substring(dumpBuffer.search("<root1>"),999999999)
    dumpBuffer="<root>"+dumpBuffer+"</root>"
   // dumpBuffer=dumpBuffer.replace('<?xml version="1.0" encoding="UTF-8" ?>',"")
   //console.log(dumpBuffer);
   // console.log(easyXML.render(parsedResults));
    //console.log(parsedResults);
fs.writeFile(dumpToPath, dumpBuffer);

    //return this.echo("Done.").exit();


/*
function padStr(i) {
    return (i < 10) ? "0" + i : "" + i;
}
    var temp = new Date();
    var dateStr = padStr(temp.getFullYear()) +"-"+
                  padStr(1 + temp.getMonth()) +"-"+
                  padStr(temp.getDate()) +"-"+
                  padStr(temp.getHours()) +"-"+
                  padStr(temp.getMinutes()) +"-"+
                  padStr(temp.getSeconds());

    console.log(dateStr);
$(this).children().children().children()     span 

<div id="37" class="song-list" style="padding-top: 3px;padding-bottom: 3px;">
<div class="songTime">21:29</div>
<div class="songTitle">
Rock-Style:
<a href="http://www.radioroks.com.ua/artists/ac-dc.html">
<span style="font-weight: bold"> AC/DC</span>
</a>
- For Those About To Rock (1981)
</div>
</div>

*/



  }
});
}
var now = new Date(Date.now());
for (var d = new Date(2013, 0, 1); d <= now; d.setDate(d.getDate() + 1)) {
//for (var d = 0; d <= 10; d ++) {
roks(d);
}