//= require jquery
//= require jquery_ujs
//= require backbone-rails
//= require_tree ./plugins
//= require_tree .
//= require_self

$(function() {
  $('textarea').autoResize();
  $('.new-window').click(function(e){
    e.preventDefault();
    window.open($(this).attr('href'));
  });
});
