# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  class Component < ActiveRecord::Base
    include HasComponents

    default_scope where(type: self.to_s) unless self == Cms::Component

    belongs_to :page, class_name: 'Cms::Page'
    belongs_to :parent, class_name: 'Cms::Component'
    has_many :components, class_name: 'Cms::Component',
      foreign_key: :parent_id, dependent: :destroy

    serialize :data, ActiveRecord::Coders::Hstore

    scope :sorted, order('position')

    after_initialize do
      self.type = self.class.to_s
      self.class.cms_attribute_defaults.each do |attribute, value|
        self.send("#{attribute}=", value) unless self.send(attribute).present?
      end
    end

    def self.symbolized
      @symbol ||= name.underscore.to_sym
    end

    def self.friendly_name
      @friendly_name ||= name.gsub('Component', '')
    end

    def self.cms_name(name)
      @friendly_name = name
    end

    def self.cms_page(boolean=nil)
      return @cms_page ||= false if boolean.nil?
      @cms_page = boolean
    end

    def self.cms_default_subcomponent(component=nil, options={})
      return @cms_default_subcomponent ||= nil if component.nil?
      @cms_default_subcomponent_options = options
      @cms_default_subcomponent = component
    end

    def self.cms_default_subcomponent_options
      @cms_default_subcomponent_options ||= {}
    end

    def self.default_subcomponent
      if cms_default_subcomponent.present?
        short_name = cms_default_subcomponent
      elsif cms_subcomponents.any?
        short_name = cms_subcomponents.first.first
      else
        return
      end
      "#{short_name}_component".camelcase.constantize
    end

    def self.cms_default_subcomponent_count
      cms_default_subcomponent_options[:count]
    end

    def self.cms_attributes
      @cms_attributes ||= {}
    end

    def self.cms_subcomponents
      @cms_subcomponents ||= {}
    end

    # Private: Define subcomponents.
    #
    # attribute - symbol of name. eg for DefinitionComponent use :definition
    # options - hash of options
    #
    # options:
    #   default - default number of subcomponent initially displayed.
    #
    # Example:
    #   cms_subcomponent :definition, default: 2
    #
    def self.cms_subcomponent(attribute, options={})
      cms_subcomponents[attribute] = options
    end

    def self.subcomponents
      @subcomponents ||= cms_subcomponents.inject({}){|memo, c|
        memo["#{c[0].to_s.camelcase}Component".constantize] = c[1]
        memo
      }
    end

    def self.fields
      cms_attributes.dup.keys
    end

    def self.fields_with_options
      cms_attributes.dup
    end

    # Private: Define an attribute for the component.
    #
    def self.cms_attribute(attribute, options={})
      html_safe = options.delete(:html_safe) || options[:class] =~ /wysiwyg/
      default   = options.delete(:default)
      cms_attribute_defaults[attribute] = default if default.present?

      cms_attributes[attribute] = options.freeze

      attribute = attribute.to_s
      return if options[:facade]
      if options[:accessor]
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{attribute}
            @#{attribute}#{html_safe ? '.to_s.html_safe' : nil}
          end

          def #{attribute}=(value)
            @#{attribute} = value
          end
        RUBY
      else
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{attribute}
            self.data['#{attribute}']#{html_safe ? '.to_s.html_safe' : nil}
          end

          def #{attribute}=(value)
            self.data['#{attribute}'] = value
          end
        RUBY
        if attribute.to_s =~ /page_id\z/
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{attribute.gsub(/_id\z/,'')}
              Cms::Page.find_by_id(self.data['#{attribute}'])
            end
          RUBY
        end
      end
    end

    def self.cms_attribute_defaults
      @cms_attribute_defaults ||= {}
    end

    def self.cms_searchable_attributes(*attr)
      @cms_searchable_attributes ||= Array.new
      @cms_searchable_attributes = (@cms_searchable_attributes + attr).uniq
      @cms_searchable_attributes
    end

    def self.searchable_attributes
      @cms_searchable_attributes ||= Array.new
    end

    def searchable_attributes
      self.class.searchable_attributes
    end

    def self.cms_link_attribute(attribute, options={})
      cms_attribute :"#{attribute}_page_id", as: :select
      cms_attribute :"#{attribute}_external_url", internal: true
      cms_attribute :"#{attribute}_target", internal: true
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{attribute}_location
          if #{attribute}_page_id.to_i > 0
            #{attribute}_page.locality_path
          else
            #{attribute}_external_url
          end
        end
      RUBY
    end

    def self.cms_dragonfly_image_attribute(attribute, options={})
      size = options[:size] || '100x100'
      cms_attribute :"#{attribute}_uid", internal: true
      cms_attribute :"#{attribute}_name", internal: true
      cms_attribute attribute, as: :file, facade: true,
        preview: lambda {|object| object.send(attribute).thumb(size).url if object.send(:"#{attribute}_uid")}
      cms_attribute :"retained_#{attribute}", as: :hidden, accessor: true
    end

    def self.cms_dragonfly_file_attribute(attribute, options={})
      cms_attribute :"#{attribute}_uid", internal: true
      cms_attribute :"#{attribute}_name", internal: true
      cms_attribute attribute, as: :file, facade: true,
        file_name: lambda {|object| object.send("#{attribute}_name") if object.send(:"#{attribute}_uid")}
      cms_attribute :"retained_#{attribute}", as: :hidden, accessor: true
    end

    def level
      return 0 if self.parent.nil?
      _level = self.parent.level
      _level += 1
      _level
    end

  end
end
