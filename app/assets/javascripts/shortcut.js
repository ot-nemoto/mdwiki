$(function(){
  // 'Save' shortcut key
  $(document).bind('keydown', 'ctrl+s', function(){
    if ($('#mdwiki_save_btn').size() > 0) {
      $('#mdwiki_save_btn').click();
      return false;
    }
    return true;
  });
  // 'Edit' shortcut key
  $(document).bind('keydown', 'e', function(){
    if ($('#mdwiki_edit_btn').size() > 0) {
      $(location).attr('href', $('#mdwiki_edit_btn').attr('href'))
      return false;
    }
    return true;
  });
  // 'Create' shortcut key
  $(document).bind('keydown', 'c', function(){
    if ($('#mdwiki_create_btn').size() > 0) {
      $(location).attr('href', $('#mdwiki_create_btn').attr('href'))
      return false;
    }
    return true;
  });
  // 'Preview' shortcut key
  $(document).bind('keydown', 'ctrl+shift+e', function(){
    if ($('#mdwiki_preview_btn').size() > 0) {
      $('#mdwiki_preview_btn').click();
      return false;
    }
    return true;
  });
});