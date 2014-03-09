# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  module RenderingHelper
    def render_component(component)
      klass = component.type
      render partial: "components/#{klass.underscore}",
      locals: {component: component, components: component.components.sorted}
    end

    def title(value=nil)
      if value.nil?
        content_for(:title)
      else
        content_for :title, value
      end
    end

    def page_title
      [ title, conf.name ].reject(&:blank?).join(' - ')
    end

  end
end
