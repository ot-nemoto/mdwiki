$(function(){
  $(document).keydown(function(e) {
    // 'Save' shortcut key 'ctrl+s'
    if (!e.shiftKey && e.ctrlKey && e.which === 83) {
      if ($('#mdwiki_save_btn').size() > 0) {
        $('#mdwiki_save_btn').click();
        return false;
      }
      return true;
    }

    // 'Preview' shortcut key 'ctrl+shift+e'
    if (e.shiftKey && e.ctrlKey && e.which === 69) {
      if ($('#mdwiki_preview_btn').size() > 0) {
        $('#mdwiki_preview_btn').click();
        return false;
      }
      return true;
    }

    // 'Edit' shortcut key 'e'
    if (!e.shiftKey && !e.ctrlKey && e.which === 69) {
      if ($(':focus').attr('id') === 'search_key') {
        return true;
      }
      if ($('#mdwiki_edit_btn').size() > 0) {
        $(location).attr('href', $('#mdwiki_edit_btn').attr('href'))
        return false;
      }
      return true;
    }

    // 'Create' shortcut key 'c'
    if (!e.shiftKey && !e.ctrlKey && e.which === 67) {
      if ($(':focus').attr('id') === 'search_key') {
        return true;
      }
      if ($('#mdwiki_create_btn').size() > 0) {
        $(location).attr('href', $('#mdwiki_create_btn').attr('href'))
        return false;
      }
      return true;
    }
  });
});
