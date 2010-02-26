// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var RM = RM || {}

RM.initialize = function(){
  this.remove_messages();
}

RM.remove_messages = function(){
  if ($("message"))
    setTimeout("$('message').remove()",3000);
}

document.observe("dom:loaded", function(){
  //RM.initialize();
});
