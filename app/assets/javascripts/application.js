//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree ./plugins
//= require email
//= require recipes
//= require_self

$(function() {
  $('textarea').autoResize();
  $('.new-window').click(function(e){
    e.preventDefault();
    window.open($(this).attr('href'));
  });
  
  FileInput.initialize();
});
