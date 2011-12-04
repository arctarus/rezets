$ ->
  new Email $('#send-email a')

class Email
  constructor: (@link) ->
    @container = '#email-container'
    @action = $('#action-links')
    @link.click @open

  open: (e) =>
    e.preventDefault()
    @insert_container()
    @style_container()
    $.get @link.attr('href'), @load_view

  insert_container: ->
    if $(@container).size() <= 0
      @action.before "<div id=\"email-container\"><p>#{@ai('cargando...')}</p></div>"

  style_container: ->
    position = $("#send-email").position()
    $(@container).css {left:position.left + 'px'}

  load_view: (data) =>
    $(@container).html data
    $('.close-email-container a').click @close
    $('a.cancel-form').click @close
    $('#add-email-message').click @add_message
    $('#new_email_recipe_form').submit @send
    $('#new_email_recipe_form').bind 'ajax:success', @success

  close: (e) =>
    e.preventDefault()
    $(@container).remove()

  add_message: (e) =>
    e.preventDefault()
    $('#email-message').show()
    $('#add-email-message').remove()

  send: =>
    $('#submit').find('a').after(@ai())

  success: (e, data, status, xhr) =>
    $(@container).html(data)
    $('.ajax-indicator').css {
      position: 'absolute',
      marginTop: '3px',
      marginLeft: '1em'}
    $('.done a').click @close
    @load_view()

  ai: (text = 'enviando...') ->
    "<span id=\"ajax-indicator\" class=\"ajax-indicator\">
    <img src=\"/assets/ajax-indicator.gif\" alt=\"#{text}\" />
    #{text}</span>"
