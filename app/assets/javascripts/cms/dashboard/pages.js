$(document).ready(function() {

  $('.dynamic-container').sortable({
    items: '> .fields',
    axis: 'y',
    cursor: 'move',
    handle: '.handle',
    update: function() {
      CMS.repositionComponentsIn($(this));
    }
  });

  $(document).on('change', '.controls select[name$="page_id]"]', function(e){
    var $this = $(this);
    var $external = $this.next('input[type=text][name$="external_url]"]');
    if ($this.find(':selected').val() == '-1') {
      $external.show();
    } else {
      $external.hide();
    }
  });
  $('.controls select[name$="page_id]"]').change();

  $('.btn-page-save').click(function() { $(this).parents('form').attr('target', ''); });
  $('.btn-page-preview').click(function() { $(this).parents('form').attr('target', '_blank'); });
});
