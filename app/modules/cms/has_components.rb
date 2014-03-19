# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  module HasComponents
    def components_attributes=(attributes)
      attributes.each do |k,v|
        next unless Cms::COMPONENT_NAMES.include?(v[:_type])
        _type     = v.delete(:_type)
        _destroy  = v.delete(:_destroy) == '1'
        id        = v.delete(:id)
        if id.present?
          component = _type.constantize.find(id)
          component.attributes = v
          component.destroy if _destroy
        else
          next if _destroy
          component = _type.constantize.new(v)
          self.save
          if self.class <= Cms::Page
            component.page = self
          else
            component.parent_id = self.id
          end
        end
        component.save unless component.destroyed?
      end
    end
  end
end
