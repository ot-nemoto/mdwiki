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
  $(location).attr(
    'href',
    '/mdwiki/search?keyword=' + encodeURIComponent($('#search_key').val()))
  return false
