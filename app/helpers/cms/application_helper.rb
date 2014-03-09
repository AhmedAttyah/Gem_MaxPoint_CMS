# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  module ApplicationHelper
    def display_flash
      content_tag :div, render_flash, id: 'flash-wrapper'
    end

    def render_flash
      content = String.new.html_safe
      classes = "alert"
      flash.each do |key, value|
        case key
        when :alert   then classes
        when :notice  then classes << " alert-success"
        else               classes << " alert-#{key}"
        end
        content << content_tag(:div, value, class: classes)
      end
      content
    end

  end
end
