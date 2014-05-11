# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  @preview = () ->
    $.post '/mdwiki/preview', 
      subject:    $('#subject').val()
      content:    $('#content').val()
#      md_title: $('#md_title').val()
#      md_content: $('#md_content').val()
      (data) ->
        $('#preview_content').html(data)
        $('img').unbind()
        $('img').bind("click", () -> return img_click(this.src))
    return false

  @save_content =() ->
    $.post '/mdwiki/save', 
      content_id: $('#content_id').val()
      parent_id:  $('#parent_id').val()
      subject:    $('#subject').val()
      content:    $('#content').val()
      (data) ->
        if data.href
          $(location).attr('href', data.href)
    return false

#  @insert_page =() ->
#    $.post '/mdwiki/insert', 
#      parent_id: $('#page_parent_id').val()
#      md_title: $('#md_title').val()
#      md_content: $('#md_content').val()
#      (data) ->
#        if data.href
#          $(location).attr('href', data.href)
#        if data.alert
#          $('#alert_message').html(data.alert)
#          $('#alert_message').show()
#          $('#md_title').focus()
#          $('#md_title').select()
#          $('#md_title').addClass('alert')
#    return false
#
#  @update_page =() ->
#    $.post '/mdwiki/update', 
#      id: $('#page_id').val()
#      md_title: $('#md_title').val()
#      md_content: $('#md_content').val()
#      (data) ->
#        if data.href
#          $(location).attr('href', data.href)
#        if data.alert
#          $('#alert_message').html(data.alert)
#          $('#alert_message').show()
#          $('#md_title').focus()
#          $('#md_title').select()
#          $('#md_title').addClass('alert')
#    return false

  @remove_page =(id) ->
    mdwiki_dialog(
      "Can I delete it?"
      () ->
        $.post '/mdwiki/remove',
          id: id
          (data) ->
            if data.href
              $(location).attr('href', data.href)
        $("#mdwiki_dlg_modal").fadeOut(250)
        return false
      () ->
        $("#mdwiki_dlg_modal").fadeOut(250)
        return false
    )
    return false;

  @remove_page_with_children =(id) ->
    mdwiki_dialog(
      "Can I delete it?"
      () ->
        $.post '/mdwiki/removeall',
          id: id
          (data) ->
            if data.href
              $(location).attr('href', data.href)
        $("#mdwiki_dlg_modal").fadeOut(250)
        return false
      () ->
        $("#mdwiki_dlg_modal").fadeOut(250)
        return false
    )
    return false;

  @remove_attachment =(id, attachment_id) ->
    mdwiki_dialog(
      "Can I delete it?"
      () ->
        $.post '/mdwiki/attachment/remove',
          id: id
          attachment_id: attachment_id
          (data) ->
            $('#attachment_content').html(data)
            $('img').unbind()
            $('img').bind("click", () -> return img_click(this.src))
        $("#mdwiki_dlg_modal").fadeOut(250)
        return false
      () ->
        $("#mdwiki_dlg_modal").fadeOut(250)
        return false
    )
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
        $('img').unbind()
        $('img').bind("click", () -> return img_click(this.src))
    return false

  @show_child = (id, current_id) ->
    if $('#cur_' + id).hasClass('mdwiki_open_btn')
      $.post '/mdwiki/list', 
        id: id 
        current_id: current_id
        (data) ->
          $('#div_' + id).html(data)
          $('#cur_' + id).removeClass('mdwiki_open_btn').addClass('mdwiki_close_btn')
    else
      $('#div_' + id).html('')
      $('#cur_' + id).removeClass('mdwiki_close_btn').addClass('mdwiki_open_btn')
    return false
  return false
