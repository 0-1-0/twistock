// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.dataTables.min
//= require jscroll
//= require bootstrap
//= require DT_bootstrap
//= require bootstrap-actions
//= require interactive

$("#random-person").tooltip({
    title: 'This is a flow of random twitter users. Find the profitable one and buy some stocks for your Investment portfolio.',
    'placement': 'bottom'
})


$("#most-valuable").tooltip({
    title: 'Explore twitter users with the highest stock price.',
    'placement': 'bottom'
})

$("#most-booming").tooltip({
    title: 'Stocks of these users are on the rise. They are growing in price because people buy them willingly.',
    'placement': 'bottom'
})

$("#most-falling").tooltip({
    title: 'Everybody in a hurry to sell the stocks of these users and they are falling in price.',
    'placement': 'bottom'
})


$("#yourprice").tooltip({
    title: 'This is a price of one stock of you. Twistock web-robots counted it value by assessing your social influence.',
    'placement': 'bottom'
})

$("#popularity").tooltip({
    title: 'Popularity of the stocks increases when users buy or sell them.',
     'placement': 'bottom'
    
})


$("#iportfolio").tooltip({
    title: 'Look whose stocks you possess.'
    
})

$("#stockholders").tooltip({
    title: 'Look who bought your stocks.'
    
})

$(".search-query").tooltip({
    title: 'Here you can find users by their nicknames.',
    'placement': 'bottom'
    
})




//mobile redirect
if (screen.width <= 1000) {
document.location = "/mobile";
}













/* 
decimal_sep: character used as deciaml separtor, it defaults to '.' when omitted
thousands_sep: char used as thousands separator, it defaults to ',' when omitted
*/
Number.prototype.toMoney = function(decimals, decimal_sep, thousands_sep)
{ 
   var n = this,
   c = isNaN(decimals) ? 2 : Math.abs(decimals), //if decimal is zero we must take it, it means user does not want to show any decimal
   d = decimal_sep || ',', //if no decimal separator is passed we use the dot as default decimal separator (we MUST use a decimal separator)

   /*
   according to [http://stackoverflow.com/questions/411352/how-best-to-determine-if-an-argument-is-not-sent-to-the-javascript-function]
   the fastest way to check for not defined parameter is to use typeof value === 'undefined' 
   rather than doing value === undefined.
   */   
   t = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep, //if you don't want to use a thousands separator you can pass empty string as thousands_sep value

   sign = (n < 0) ? '-' : '',

   //extracting the absolute value of the integer part of the number and converting to string
   i = parseInt(n = Math.abs(n).toFixed(c)) + '', 

   j = ((j = i.length) > 3) ? j % 3 : 0; 
   return sign + (j ? i.substr(0, j) + t : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t); 
}