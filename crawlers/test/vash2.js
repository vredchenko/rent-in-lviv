var   casper = require('casper').create({
    verbose: true
  });

//For our scraper we want only html node props passed in as args.
var properties = casper.cli.args;
var url = casper.cli.options.url;
var selector = casper.cli.options.selector;

var url = "http://vashmagazin.ua/cat/catalog/?rub=128&subrub=1";
var selector = 'table.ogolosh-avto-sp tbody';
var properties = ["innerHTML"];
//"innerText", 
casper.start(url, function(){
// this.echo(selector);
// this.echo(properties);
data = this.evaluate(function(selector, properties){

var selector_content = document.querySelectorAll(selector);
var urls = [];
for (var i = 0; i < selector_content.length; i++) {
var element = selector_content[i];
var datapoint = {};
for (var j = 0; j < properties.length; j++) {
var prop = properties[j];
datapoint[prop] = element[prop];
};
urls.push(datapoint);
}
return JSON.stringify({stories:urls});
}, selector, properties)
});

casper.run(function() {
    this.echo(data).exit();
});

