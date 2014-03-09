# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  class Page < ActiveRecord::Base
    include HasComponents

    belongs_to :locality
    belongs_to :parent, class_name: "Cms::Page"
    has_many :pages, class_name: "Cms::Page", foreign_key: :parent_id
    has_many :components, dependent: :destroy
    has_many :links

    after_save :expire_select_cache

    validate :parent_not_self
    validates :title, presence: true
    validates :slug, format: {with: /\A[a-z0-9-]*\z/, message: "may only contain a-z, 0-9, or dashes"}

    scope :in, lambda { |locality|
      return scoped if locality.nil?
      where(locality_id: locality.id)
    }

    scope :search, lambda { |text|
      includes(:components).
        where(published: true).
        where("CAST(AVALS(cms_components.data) AS TEXT) @@ ?", text)
    }

    CONTENT = 'content'.freeze
    BLOG = 'blog'.freeze
    POST = 'post'.freeze
    TYPES = {
      CONTENT => Cms::ContentPage.name,
      BLOG => Cms::BlogPage.name,
      POST => Cms::PostPage.name
    }.freeze

    def self.home_page
      where(type: ['', nil, Cms::ContentPage.name], parent_id: nil, slug: ['', nil]).first
    end
    def self.post_page
      where(type: Cms::PostPage.name).first
    end

    def _type=(value)
      raise "Illegal page type" unless TYPES[value]
      self.type = TYPES[value]
    end

    def _type
      TYPES.detect{|k, v| v == read_attribute(:type)}.try(:first)
    end

    def self.select_for(locality, expire=false)
      @__page_select_cache ||= {}
      @__page_select_cache.delete(locality.id) if expire
      @__page_select_cache[locality.id] ||= Cms::Page.in(locality).
        sort{|a,b| a.path <=> b.path}.
        collect{|p| [[p.title, p.path].join(' - '), p.id]}
      @__page_select_cache[locality.id].dup
    end

    def path
      @path ||= "/#{path_segments.join('/')}"
    end

    def locality_path
      @locality_path ||= "/#{locality.slug}#{path}"
    end

    def path_segments
      return Array.new if self.parent.nil?
      _segments = self.parent.path_segments
      _segments << self.slug
      _segments
    end

    private

    def parent_not_self
      return unless self.parent == self
      errors.add :parent_id, "cannot be this page"
    end

    def expire_select_cache
      self.class.select_for(self.locality, true)
      Link.select_for(self.locality, true)
    end

  end
end
