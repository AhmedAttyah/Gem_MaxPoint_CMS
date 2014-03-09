# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  class Post < ActiveRecord::Base
    belongs_to :locality
    belongs_to :author, class_name: 'Cms::User'
    has_many :comments, dependent: :destroy
    has_many :approved_comments, class_name: 'Cms::Comment',
      conditions: "approved_by_id IS NOT NULL"
    belongs_to :category
    has_and_belongs_to_many :tags, join_table: 'cms_posts_cms_tags'

    validates :locality,      presence: true
    validates :author,        presence: true
    validates :title,         presence: true
    validates :body,          presence: true
    validates :slug,          presence: true, format: {with: /\A[a-z0-9-]*\z/}
    validates :published_at,  presence: true

    after_initialize do |post|
      post.published = true if post.published.nil?
      post.published_at ||= Time.now
    end
    before_validation :default_slug
    before_save :set_tag_locality

    scope :search, lambda {|text|
      where("title @@ :q OR body @@ :q", q: text)
    }

    scope :in, lambda { |locality|
      return scoped if locality.nil?
      where(locality_id: locality.id)
    }
    scope :ordered,         order('published_at DESC')
    scope :published,       where(published: true)
    scope :published_after, lambda {|time=Time.now|
      where("published_at <= ?", time)
    }
    scope :not_published,   where(published: false)
    scope :published_on,    lambda {|date|
      where("published_at >= ? AND published_at <= ?", date, date.tomorrow)
    }
    scope :with_slug,       lambda {|slug|
      where(slug: slug)
    }

    def slug=(value)
      return if locked?
      write_attribute :slug, value
    end

    def locked?
      persisted? && published? && published_at <= Time.now
    end

    def to_param
      "#{id}-#{slug.to_s.parameterize}"
    end

    def tag_names
      tags.map(&:name).join(',')
    end

    def tag_names=(str)
      user_tag_names = str.split(',')
      existing_tags = Tag.where(name: user_tag_names)
      new_tag_names = user_tag_names - existing_tags.map(&:name)
      Tag.create!(new_tag_names.map {|n| {name: n}})

      self.tags = Tag.where(name: user_tag_names)
    end

    def path
      raise "post not saved -- can't render path" unless persisted?
      @path ||= [
        published_at.year,
        published_at.month,
        published_at.day,
        slug
      ].join('/')
    end

    def full_path
      @full_path ||= BlogPage.in(locality).first.post_path(self)
    end

    def locality_full_path
      @locality_full_path ||= BlogPage.in(locality).first.locality_post_path(self)
    end

    private

    def default_slug
      return if slug.present?
      _slug = title.downcase.strip
      _slug = _slug.gsub(/\s+/, '-')
      _slug = _slug.gsub(/-+/, '-')
      _slug = _slug.gsub(/[^a-z0-9\-]/, '')
      self.slug = _slug
    end

    def set_tag_locality
      tags.update_all(locality_id: locality_id) if locality_id.present?
    end

  end
end
