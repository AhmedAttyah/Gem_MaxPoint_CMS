# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

class HorizontalFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, :tag, :image_tag, to: :@template
  delegate :current_locality, to: :"@template.controller"

  %w[text_field text_area password_field file_field hidden_field
     datetime_select text_area grouped_collection_select
     phone_field email_field].each do |method_name|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def h_#{method_name}(name, *args)
        options     = args.extract_options!
        label_text  = options.delete(:label)
        group_class = options.delete(:group_class)
        if object.errors[name].any?
          options[:class] = "\#{options[:class]} error"
          options[:data] ||= Hash.new
          options[:data][:error] = object.errors[name].join(', ')
        end
        args << options
        content_tag :div, class: "control-group" << " \#{group_class}" do
          label(name, label_text, class: 'control-label') +
            content_tag(:div, class: 'controls') { #{method_name}(name, *args) }
        end
      end
    RUBY
  end

  def h_select(name, choices, options={}, html_options={})
    label_text  = options.delete(:label)
    group_class = html_options.delete(:group_class)
    if object.errors[name].any?
      html_options[:class] = "#{options[:class]} error"
      html_options[:data] ||= Hash.new
      html_options[:data][:error] = object.errors[name].join(', ')
    end
    if name.to_s =~ /page_id\z/
      options.merge!(include_blank: true)
      choices       = Cms::Page.select_for(current_locality)
      base_name     = name.to_s.gsub(/_page_id\z/,'')
      external_url  = "#{base_name}_external_url"
      if object.respond_to?(external_url)
        choices.insert 0, ["[External URL]", -1]
        label_text  = base_name.humanize
        tags        = select(name, choices, options, html_options)
        tags << text_field(external_url, placeholder: 'https://example.com')
        target = "#{base_name}_target"
        if object.respond_to?(target)
          tags << select(target, Cms::Link::TARGET_OPTIONS, prompt: "Target").html_safe
        end
      else
        tags = select(name, choices, options, html_options)
      end
    else
      tags = select(name, choices, options, html_options)
    end
    content_tag :div, class: "control-group" << " #{group_class}" do
      label(name, label_text, class: 'control-label') +
        content_tag(:div, class: 'controls') { tags }
    end
  end

  def h_check_box(name, *args)
    options = args.extract_options!
    options[:label] ||= name.to_s.humanize
    if object.errors[name].any?
      options[:class] = "#{options[:class]} error"
      options[:data] ||= Hash.new
      options[:data][:error] = object.errors[name].join(', ')
    end
    content_tag :div, class: 'control-group' do
      content_tag :div, class: 'controls' do
        label name, options[:label], class: 'checkbox' do
          check_box(name) + " #{options[:label]}"
        end
      end
    end
  end

  def h_submit(*args)
    content_tag :div, class: 'control-group' do
      content_tag :div, class: 'controls' do
        submit(*args)
      end
    end
  end

  def h_cms_file_field(name, *args)
    #raise if name == :pdf
    options     = args.extract_options!
    label_text  = options.delete(:label)
    group_class = options.delete(:group_class)
    if object.errors[name].any?
      options[:class] = "#{options[:class]} error"
      options[:data] ||= Hash.new
      options[:data][:error] = object.errors[name].join(', ')
    end
    args << options
    options[:preview]   ||= lambda{|x| nil}
    options[:file_name] ||= lambda{|x| nil}
    preview_url         = options[:preview].call(object)
    file_name_text      = options[:file_name].call(object)
    tags                = file_field(name)
    tags << ('<br/>' + image_tag(preview_url)).html_safe  if preview_url.present?
    tags << ('<br/>' + file_name_text).html_safe          if file_name_text.present?
    if object.send(name).present?
      remove_name = "remove_#{name}"
      tags << ('<br/>' + label(remove_name, class: 'checkbox inline'){check_box(remove_name) + "Remove"}).html_safe
    end
    content_tag :div, class: "control-group" << " #{group_class}" do
      label(name, label_text, class: 'control-label') +
        content_tag(:div, class: 'controls') { tags }
    end
  end

  def h_cms_field(name, options={})
    options = options.dup
    return if options.delete(:internal)
    preview = options.delete(:preview)
    field_tag = case options.delete(:as)
    when :select
      choices       = options.delete(:choices)  || {}
      html_options  = options.delete(:html)     || {}
      h_select name, choices, options, html_options
    when :file
      h_cms_file_field name, options.merge(preview: preview)
    when :hidden
      hidden_field name, options
    when :textarea
      options[:class] = "#{options[:class]} input-block-level"
      h_text_area name, options
    else
      options[:class] = "#{options[:class]} input-block-level"
      h_text_field name, options
    end
  end

  private

  # Private: Filter keys passed to tags.
  #
  def objectify_options(options)
    super.except(:label)
  end
end
