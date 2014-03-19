$(document).ready(function() {

  $(document).on('click', 'form a.add_child', function() {
    var $this       = $(this);
    var $container  = $($this.parents('.action').prev('.dynamic-container'));
    var template    = $this.data('template');
    var $content    = $($('#' + template + '_fields_template').html());
    var $inputs     = $content.find('input[name], textarea[name], select[name]');
    var $context    = $this.closest('.fields').find('input:first');
    var context     = ($context.prop('name')||'').replace(new RegExp('\[[a-z_]+\]$'), '');
    var time        = new Date().getTime();

    if(context) {
      var stem = $inputs.prop('name').match(/(.*)\[.*_attributes\]/)[1];
      $inputs.each(function(idx, element){
        var $element  = $(element);
        var name      = $element.prop('name').replace(stem, context);
        $element.prop('name', name);
      });
    }

    $inputs.each(function(idx, element){
      var $element  = $(element);
      var name      = $element.prop('name').replace(/\[new_.*?\]/, '['+time+']');
      var newId     = name.replace(/]/g, '').replace(/\[/g, '_');
      var id        = $element.prop('id');
      $element.prop('name', name);
      $content.find('#' + id).prop('id', newId);
    });

    $container.append($content);
    CMS.repositionComponentsIn($container);
    for(var instanceName in CKEDITOR.instances) {
      CKEDITOR.remove(CKEDITOR.instances[instanceName]);
    }
    $('div[id^="cke_page_components_attributes"]').remove();
    CKEDITOR.replaceAll('wysiwyg');
  });

  $(document).on('click', 'form a.remove_child', function() {
    var $this = $(this);
    var $fields = $($this.parents('.fields')[0]);
    var destroy_field = $fields.find('input[type=hidden][name$="[_destroy]"]')[0];
    if(destroy_field) destroy_field.value = '1';
    $fields.hide();
  });

});
