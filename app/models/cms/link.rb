# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  class Link < ActiveRecord::Base
    belongs_to :locality
    belongs_to :page
    belongs_to :parent, class_name: "Cms::Link"
    has_many :links, class_name: "Cms::Link", foreign_key: :parent_id, order: 'position'

    validate :parent_not_self

    scope :in, lambda { |locality|
      return scoped if locality.nil?
      where(locality_id: locality.id)
    }

    scope :position, lambda { |positions|
      where(position: Array(positions))
    }

    TARGET_OPTIONS = %w(_self _blank _parent _top).freeze

    before_save :set_text_if_blank
    after_save :expire_select_cache

    def self.select_for(locality, expire=false)
      @__link_select_cache ||= {}
      @__link_select_cache.delete(locality.id) if expire
      @__link_select_cache[locality.id] ||= Cms::Link.in(locality).
        sort{|a,b| a.location <=> b.location}.
        collect{|l| [[l.text, l.page.try(:title)].join(' - '), l.id] }
      @__link_select_cache[locality.id].dup
    end

    def location
      page.present? ? page.path : external_url
    end

    def locality_location
      page.present? ? page.locality_path : external_url
    end

    def external?
      self.page_id.nil?
    end

    private

    def parent_not_self
      return unless self.parent == self
      errors.add :parent_id, "cannot be this link"
    end

    def set_text_if_blank
      return unless self.text.blank?
      self.text = self.name
    end

    def expire_select_cache
      self.class.select_for(self.locality, true)
      Page.select_for(self.locality, true)
    end

  end
end
