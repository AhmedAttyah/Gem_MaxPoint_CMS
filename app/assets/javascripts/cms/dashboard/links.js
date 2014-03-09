$(document).ready(function() {
  $('#link_text').on('keyup focusout', function(e){
    if (location.pathname.match(/edit(\/?)(\?.*)?$/) != null) return;
    var value = $(this).val();
    value = value.toLowerCase();
    value = value.replace(/^\s+/g, '');
    value = value.replace(/\s+$/g, '');
    value = value.replace(/\s+/g, '-');
    value = value.replace(/-+/g, '-');
    value = value.replace(/[^a-z0-9\-]/g, '');
    $('#link_name').val(value);
  });
});
