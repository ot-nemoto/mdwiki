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

  @insert_page =() ->
    $.post '/mdwiki/insert', 
      parent_id: $('#page_parent_id').val()
      md_title: $('#md_title').val()
      md_content: $('#md_content').val()
      (data) ->
        if data.href
          $(location).attr('href', data.href)
    return false

  @update_page =() ->
    $.post '/mdwiki/update', 
      id: $('#page_id').val()
      md_title: $('#md_title').val()
      md_content: $('#md_content').val()
      (data) ->
        if data.href
          $(location).attr('href', data.href)
    return false

  @remove_page =(id) ->
    $.post '/mdwiki/remove',
      id: id
      (data) ->
        if data.href
          $(location).attr('href', data.href)
    return false

  @remove_attachment =(id, file) ->
    $.post '/mdwiki/attachment/remove',
      id: id
      file: file
      (data) ->
        $('#attachment_content').html(data)
    return false

  @upload_attachment =() ->
    $form  = $('#mdwiki_attachment_form')
    form_data = new FormData($form[0])
    $.ajax '/mdwiki/attachment/upload',
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

  @show_child = (id) ->
    if $('#cur_' + id).hasClass('mdwiki_open_btn')
      $.post '/mdwiki/list', 
        id: id 
        (data) ->
          $('#div_' + id).html(data)
          $('#cur_' + id).removeClass('mdwiki_open_btn').addClass('mdwiki_close_btn')
    else
      $('#div_' + id).html('')
      $('#cur_' + id).removeClass('mdwiki_close_btn').addClass('mdwiki_open_btn')
    return false
