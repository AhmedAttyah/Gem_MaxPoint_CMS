# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  class Category < ActiveRecord::Base
    belongs_to :locality
    has_many :posts

    validates :name, presence: true

    before_validation :default_slug

    scope :in, lambda { |locality|
      return scoped if locality.nil?
      where(locality_id: locality.id)
    }

    private

    def default_slug
      return if slug.present?
      _slug = name.downcase.strip
      _slug = _slug.gsub(/\s+/, '-')
      _slug = _slug.gsub(/-+/, '-')
      _slug = _slug.gsub(/[^a-z0-9\-]/, '')
      self.slug = _slug
    end
  end
end
