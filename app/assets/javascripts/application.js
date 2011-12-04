//= require jquery
//= require jquery_ujs
//= require_self
//= require_tree .

$(function() {
  $('textarea').autoResize();
  $('.new-window').click(function(){
    window.open($(this).attr('href'));
  });
});
