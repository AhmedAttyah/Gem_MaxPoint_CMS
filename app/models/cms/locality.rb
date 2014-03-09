# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  class Locality < ActiveRecord::Base
    has_many :pages, dependent: :destroy
    has_many :posts, dependent: :destroy
    validates :slug, presence: true, uniqueness: {
      case_insensitive: true,
      allow_blank: false,
      allow_nil: false
    }
    validates :name, presence: true

    before_validation :normalize_slug

    scope :alphabetical, order(:name)

    def normalize_slug
      self.slug = self.slug.to_s.downcase.gsub(/\W/, '')
      self.slug = nil if self.slug == ""
    end
  end
end
