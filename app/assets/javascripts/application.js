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
  
  FileInput.initialize();
});

var FileInput = {
  initialize: function(){
    $('input[type=file]').on('change', FileInput.open);
  },
  open: function(e) {
    var $this = $(this);
    var $label = $this.prev();
    var path = $this.val().split('\\');
    var filename = path[path.length-1];
    $this.siblings('span.filename').html(filename);
  }
};
