# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
document.onkeydown =(event)->
  if !event.ctrlKey || event.keyCode != 83
    return true
  if $("#mdwiki_save_btn").size() > 0
    $("#mdwiki_save_btn").click()
    return false
  return true
