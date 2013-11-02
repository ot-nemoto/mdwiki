# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  @login = () ->
    $.post '/mdwiki/login', 
      username: $('#username').val()
      password: $('#password').val()
      (data) ->
        if data.href
          $(location).attr('href', data.href)
        if data.alert
          $('#alert').html(data.alert)
    return false

  @logout = () ->
    $.post '/mdwiki/logout',
      (data) ->
        if data.href
          $(location).attr('href', data.href)
    return false
