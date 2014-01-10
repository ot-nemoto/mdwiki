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
});
