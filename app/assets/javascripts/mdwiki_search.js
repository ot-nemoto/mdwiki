
$(document).ready(function(){
  $('#search_key').keypress(function(e) {
    if (e.which === 13) {
      return search_pages();
    }
  });
});

$(document).on('page:load', function(){
  $('#search_key').keypress(function(e) {
    if (e.which === 13) {
      return search_pages();
    }
  });
});

search_pages = function() {
  var params;
  params = '?keyword=' + encodeURIComponent($('#search_key').val());
  if ($('#chk_title').prop('checked')) {
    params += '&subject=1';
  }
  if ($('#chk_content').prop('checked')) {
    params += '&content=1';
  }
  $(location).attr('href', '/mdwiki/search' + params);
  return false;
};
