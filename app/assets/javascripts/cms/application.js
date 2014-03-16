//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require bootstrap
//= require bootstrap-wysihtml5
//= require ckeditor/init
//= require select2
//= require_tree .
//= require_self

window.CMS = {}

$(document).ready(function() {

  jQuery.expr[':'].parents = function(a,i,m){
    var match = m[3].match(/(!*)(.*)/);
    if (match[1] == '!') {
      return jQuery(a).parents(match[2]).length < 1;
    } else {
      return jQuery(a).parents(match[2]).length > 0;
    }
  };
  jQuery.expr[':'].display = function(a,i,m){
    var match = m[3].match(/(!*)(.*)/);
    if (match[1] == '!') {
      return jQuery(a).css('display') != match[2];
    } else {
      return jQuery(a).css('display') == match[2];
    }
  };

  CMS.repositionComponentsIn = function($container) {
    $container.find('[name$="[position]"]').each(function(idx, element){
      $(element).val(idx + 1);
    });
  }

  CMS.displayErrors = function() {
    $( '.error:not(.control-group)').each(function(idx, element) {
      var $element  = $(element);
      var error     = $element.data('error');
      if (error != undefined) {
        var span = '<span class="help-inline">' + error + '</span>';
        if ($element.prop('type') == 'checkbox') {
          $element.parents('label').append('<br />' + span);
        } else {
          $element.after(span);
        }
        $($element.parents('.control-group')[0]).addClass('error');
      }
    });
  };

  CMS.displayErrors();

  CKEDITOR.replaceAll('wysiwyg');

  $(".tag-select").select2({
    tags: function() { return $("input.tag-select").data('tags').split(',') },
    tokenSeparators: [","]
  });
});
