//= require jquery
//= require jquery_ujs
//= require_tree ./plugins
//= require email
//= require_self

$(function() {
  $('textarea').autoResize();
  $('.new-window').click(function(e){
    e.preventDefault();
    window.open($(this).attr('href'));
  });
});
