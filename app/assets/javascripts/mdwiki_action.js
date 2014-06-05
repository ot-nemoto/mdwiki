preview = function() {
  spinner.spin(document.getElementById('spinner'));
  $.post('/mdwiki/preview', {
    subject: $('#subject').val(),
    content: $('#content').val()
  }, function(data) {
    $('#preview_content').html(data);
    $('img').unbind();
    $('img').bind("click", function() {
      img_click(this.src);
    });
    spinner.stop();
  });
  return false;
};

save_content = function() {
  spinner.spin(document.getElementById('spinner'));
  $.post('/mdwiki/save', {
    content_id: $('#content_id').val(),
    parent_id: $('#parent_id').val(),
    subject: $('#subject').val(),
    content: $('#content').val()
  }, function(data) {
    if (data.href) {
      $(location).attr('href', data.href);
    }
    spinner.stop();
  });
  return false;
};

remove_page = function(id) {
  mdwiki_dialog("Can I delete it?", function() {
    spinner.spin(document.getElementById('spinner'));
    $.post('/mdwiki/remove', {
      id: id
    }, function(data) {
      if (data.href) {
        $(location).attr('href', data.href);
      }
      spinner.stop();
    });
    $("#mdwiki_dlg_modal").fadeOut(250);
    return false;
  }, function() {
    $("#mdwiki_dlg_modal").fadeOut(250);
    return false;
  });
  return false;
};

remove_account = function() {
  mdwiki_dialog("Account will not be undone. Are you sure?", function() {
    $("#remove_account").click();
    $("#mdwiki_dlg_modal").fadeOut(250);
    return false;
  }, function() {
    $("#mdwiki_dlg_modal").fadeOut(250);
    return false;
  });
  return false;
};

remove_page_with_children = function(id) {
  mdwiki_dialog("Can I delete it?", function() {
    spinner.spin(document.getElementById('spinner'));
    $.post('/mdwiki/removeall', {
      id: id
    }, function(data) {
      if (data.href) {
        $(location).attr('href', data.href);
      }
      spinner.stop();
    });
    $("#mdwiki_dlg_modal").fadeOut(250);
    return false;
  }, function() {
    $("#mdwiki_dlg_modal").fadeOut(250);
    return false;
  });
  return false;
};

remove_attachment = function(id, attachment_id) {
  mdwiki_dialog("Can I delete it?", function() {
    spinner.spin(document.getElementById('spinner'));
    $.post('/mdwiki/attachment/remove', {
      id: id,
      attachment_id: attachment_id
    }, function(data) {
      $('#attachment_content').html(data);
      $('img').unbind();
      $('img').bind("click", function() {
        img_click(this.src);
      });
      spinner.stop();
    });
    $("#mdwiki_dlg_modal").fadeOut(250);
    return false;
  }, function() {
    $("#mdwiki_dlg_modal").fadeOut(250);
    return false;
  });
  return false;
};

upload_attachment = function() {
  var $form, form_data;
  $form = $('#mdwiki_attachment_form');
  form_data = new FormData($form[0]);
  spinner.spin(document.getElementById('spinner'));
  $.ajax('/mdwiki/attachment/upload', {
    type: 'POST',
    processData: false,
    contentType: false,
    data: form_data,
    enctype: 'multipart/form-data',
    dataType: 'text',
    error: function(jqXHR, textStatus, errorThrown) {
      alert(errorThrown);
      spinner.stop();
    },
    success: function(data, textStatus, jqXHR) {
      $('#attachment_content').html(data);
      $('img').unbind();
      $('img').bind("click", function() {
        img_click(this.src);
      });
      spinner.stop();
    }
  });
  return false;
};

show_child = function(id, current_id) {
  if ($('#cur_' + id).hasClass('mdwiki_open_btn')) {
    spinner.spin(document.getElementById('spinner'));
    $.post('/mdwiki/list', {
      id: id,
      current_id: current_id
    }, function(data) {
      $('#div_' + id).html(data);
      $('#cur_' + id).removeClass('mdwiki_open_btn').addClass('mdwiki_close_btn');
      spinner.stop();
    });
  } else {
    $('#div_' + id).html('');
    $('#cur_' + id).removeClass('mdwiki_close_btn').addClass('mdwiki_open_btn');
  }
  return false;
};

var opts = {
  lines: 15, // The number of lines to draw
  length: 10, // The length of each line
  width: 5, // The line thickness
  radius: 20, // The radius of the inner circle
  corners: 1, // Corner roundness (0..1)
  rotate: 0, // The rotation offset
  direction: 1, // 1: clockwise, -1: counterclockwise
  color: '#ff0000', // #rgb or #rrggbb or array of colors
  speed: 2, // Rounds per second
  trail: 60, // Afterglow percentage
  shadow: false, // Whether to render a shadow
  hwaccel: false, // Whether to use hardware acceleration
  className: 'spinner', // The CSS class to assign to the spinner
  zIndex: 2e9, // The z-index (defaults to 2000000000)
  top: '50%', // Top position relative to parent
  left: '50%' // Left position relative to parent
};

var spinner = new Spinner(opts);
