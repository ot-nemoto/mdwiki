# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#search_key').keypress (e) ->
    if e.which == 13
      return search_pages()

  @search_pages = () ->
    return search_pages()

search_pages =() ->
  params  = '?keyword=' + encodeURIComponent($('#search_key').val())
  if !$('#chk_title').prop('checked')
    params += '&no_t='
  if !$('#chk_content').prop('checked')
    params += '&no_c='
  $(location).attr(
    'href',
    '/mdwiki/search' + params)
  return false
