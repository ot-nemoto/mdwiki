
$(window).resize(function() {
  var img_height, img_width;
  // dialog
  adjust_position("#mdwiki_dlg");
  // image preview
  img_height = $("#mdwiki_attach_img").height();
  img_width = $("#mdwiki_attach_img").width();
  adjust_position("#mdwiki_attach", img_height, img_width);
  return false;
});  

mdwiki_dialog = function(message, accept_func, cancel_func) {
  adjust_position("#mdwiki_dlg");
  $("#mdwiki_dlg_message").text(message);
  $("#mdwiki_dlg_accept_btn").unbind();
  $("#mdwiki_dlg_accept_btn").bind("click", accept_func);
  $("#mdwiki_dlg_cancel_btn").unbind();
  $("#mdwiki_dlg_cancel_btn").bind("click", cancel_func);
  $("#mdwiki_dlg_bg").unbind();
  $("#mdwiki_dlg_bg").bind("click", cancel_func);
  $("#mdwiki_dlg_modal").fadeIn(500);
  return false;
};

adjust_position = function(target, height, width) {
  var margin_left, margin_top;
  if (height === void 0) {
    height = $(target).height();
  }
  if (width === void 0) {
    width = $(target).width();
  }
  margin_top = ($(window).height() - height) / 2;
  margin_left = ($(window).width() - width) / 2;
  return $(target).css({
    top: margin_top + "px",
    left: margin_left + "px"
  });
};
