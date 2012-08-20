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
    title: 'Stocks of these users are on the rise. They are bought, and they grow in price.',
    'placement': 'bottom'
})

$("#most-falling").tooltip({
    title: 'Everybody in a hurry to sell the stocks of these users and they are falling in price.',
    'placement': 'bottom'
})
