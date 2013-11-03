# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  @preview = () ->
    $.post '/mdwiki/preview', 
      md_title: $('#md_title').val()
      md_content: $('#md_content').val()
      (data) ->
        $('#preview_content').html(data)
    return false

  @insert =() ->
    $.post '/mdwiki/' + $('#page_id').val() + '/insert', 
      md_title: $('#md_title').val()
      md_content: $('#md_content').val()
      (data) ->
        if data.href
          $(location).attr('href', data.href)
    return false

  @update =() ->
    $.post '/mdwiki/' + $('#page_id').val() + '/update', 
      md_title: $('#md_title').val()
      md_content: $('#md_content').val()
      (data) ->
        if data.href
          $(location).attr('href', data.href)
    return false

  @upload =() ->
    $form  = $('#mdwiki_attachment_form')
    form_data = new FormData($form[0])
    $.ajax '/mdwiki/' + $('#page_id').val() + '/upload',
      type: 'POST'
      processData : false
      contentType : false
      data: form_data
      enctype  : 'multipart/form-data'
      dataType : 'text'
      error: (jqXHR, textStatus, errorThrown) ->
        alert errorThrown
      success: (data, textStatus, jqXHR) ->
        $('#attachment_content').html(data)
    return false

  @showChild = (id) ->
    if $('#cur_' + id).hasClass('mdwiki_open_btn')
      $.post '/mdwiki/' + id + '/list', 
        (data) ->
          $('#div_' + id).html(data)
          $('#cur_' + id).removeClass('mdwiki_open_btn').addClass('mdwiki_close_btn')
    else
      $('#div_' + id).html('')
      $('#cur_' + id).removeClass('mdwiki_close_btn').addClass('mdwiki_open_btn')
