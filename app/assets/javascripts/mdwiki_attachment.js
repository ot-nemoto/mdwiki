
$(document).ready(function(){
  $('img').click(function() {
    return img_click(this.src);
  });
});

$(document).on('page:load', function(){
  $('img').click(function() {
    return img_click(this.src);
  });
});

img_click = function(src) {
  mdwiki_attach_preview(src, function() {
    $("#mdwiki_attach_modal").fadeOut(250);
    return false;
  });
  return false;
};

mdwiki_attach_preview = function(src, close_func) {
  $("#mdwiki_attach_img").attr("src", src);
  $("#mdwiki_attach_img").unbind();
  $("#mdwiki_attach_img").bind("load", function() {
    var img_height, img_width;
    img_height = $("#mdwiki_attach_img").height();
    img_width = $("#mdwiki_attach_img").width();
    return adjust_position("#mdwiki_attach", img_height, img_width);
  });
  $("#mdwiki_attach_img").bind("click", close_func);
  $("#mdwiki_attach").unbind();
  $("#mdwiki_attach").bind("click", close_func);
  $("#mdwiki_attach_bg").unbind();
  $("#mdwiki_attach_bg").bind("click", close_func);
  $("#mdwiki_attach_modal").fadeIn(500);
  return false;
};
