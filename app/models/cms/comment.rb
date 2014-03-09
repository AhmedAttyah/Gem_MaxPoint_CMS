# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  class Comment < ActiveRecord::Base
    belongs_to :post
    belongs_to :parent, class_name: 'Cms::Comment'
    has_many :comments, foreign_key: :parent_id, class_name: 'Cms::Component',
      dependent: :destroy
    belongs_to :approved_by, class_name: 'Cms::User'

    validates :name, presence: true
    validates :email, presence: true
    validates :body, presence: true

    scope :in, lambda { |locality|
      return scoped if locality.nil?
      joins(:post).where(cms_posts: {locality_id: locality.id})
    }
    scope :unapproved, where(approved_by_id: nil)
    scope :ascending, order('created_at ASC')
    scope :descending, order('created_at DESC')

  end
end
