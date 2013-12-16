# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#username').focus()

  $('#password').keypress (e) ->
    if e.which == 13
      return login()

  @login = () ->
    return login()

  @logout = () ->
    $.post '/mdwiki/logout',
      (data) ->
        if data.href
          $(location).attr('href', data.href)
    return false

login =() ->
  $.post '/mdwiki/login', 
    username: $('#username').val()
    password: $('#password').val()
    (data) ->
      if data.href
        $(location).attr('href', data.href)
      if data.alert
        $('#alert_message').html(data.alert)
        $('#alert_message').show()
        $('#password').focus()
        $('#password').select()
        $('#username').addClass('alert')
        $('#password').addClass('alert')
  return false
