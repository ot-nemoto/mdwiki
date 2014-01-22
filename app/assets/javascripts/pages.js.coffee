# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(window).resize ->
    # dialog
    adjust_position("#mdwiki_dlg")
    # image preview
    img_height = $("#mdwiki_attach_img").height()
    img_width  = $("#mdwiki_attach_img").width()
    adjust_position("#mdwiki_attach", img_height, img_width)
    return false

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
        if data.alert
          $('#alert_message').html(data.alert)
          $('#alert_message').show()
          $('#md_title').focus()
          $('#md_title').select()
          $('#md_title').addClass('alert')
    return false

  @update_page =() ->
    $.post '/mdwiki/update', 
      id: $('#page_id').val()
      md_title: $('#md_title').val()
      md_content: $('#md_content').val()
      (data) ->
        if data.href
          $(location).attr('href', data.href)
        if data.alert
          $('#alert_message').html(data.alert)
          $('#alert_message').show()
          $('#md_title').focus()
          $('#md_title').select()
          $('#md_title').addClass('alert')
    return false

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

  @remove_attachment =(id, file) ->
    mdwiki_dialog(
      "Can I delete it?"
      () ->
        $.post '/mdwiki/attachment/remove',
          id: id
          file: file
          (data) ->
            $('#attachment_content').html(data)
        $("#mdwiki_dlg_modal").fadeOut(250)
        return false
      () ->
        $("#mdwiki_dlg_modal").fadeOut(250)
        return false
    )
    return false

  $("img").click ->
    mdwiki_attach_preview(
      this.src
      () ->
        $("#mdwiki_attach_modal").fadeOut(250)
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

mdwiki_dialog =(message, accept_func, cancel_func) ->
  # Adjustment position
  adjust_position("#mdwiki_dlg")
  # Set message
  $("#mdwiki_dlg_message").text(message)
  # bind for mdwiki_dlg_accept_btn
  $("#mdwiki_dlg_accept_btn").unbind()
  $("#mdwiki_dlg_accept_btn").bind("click", accept_func)
  # bind for mdwiki_dlg_cancel_btn
  $("#mdwiki_dlg_cancel_btn").unbind()
  $("#mdwiki_dlg_cancel_btn").bind("click", cancel_func)
  # bind for mdwiki_dlg_bg
  $("#mdwiki_dlg_bg").unbind()
  $("#mdwiki_dlg_bg").bind("click", cancel_func)
  # Open
  $("#mdwiki_dlg_modal").fadeIn(500)
  return false;

mdwiki_attach_preview =(src, close_func) ->
  # insert image source
  $("#mdwiki_attach_img").attr("src", src)
  # bind for mdwiki_attach_img
  $("#mdwiki_attach_img").unbind()
  $("#mdwiki_attach_img").bind(
    "load"
    () ->
      # Adjustment position
      img_height = $("#mdwiki_attach_img").height()
      img_width  = $("#mdwiki_attach_img").width()
      adjust_position("#mdwiki_attach", img_height, img_width)
  )
  $("#mdwiki_attach_img").bind("click", close_func)
  # bind for mdwiki_attach
  $("#mdwiki_attach").unbind()
  $("#mdwiki_attach").bind("click", close_func)
  # bind for mdwiki_attach_bg
  $("#mdwiki_attach_bg").unbind()
  $("#mdwiki_attach_bg").bind("click", close_func)
  # Open
  $("#mdwiki_attach_modal").fadeIn(500)
  return false;

adjust_position =(target, height, width) ->
  if height == undefined
    height = $(target).height()
  if width == undefined
    width  = $(target).width()
  margin_top  = ($(window).height() - height) / 2
  margin_left = ($(window).width() - width) / 2
  $(target).css
    top: margin_top + "px"
    left: margin_left + "px"
