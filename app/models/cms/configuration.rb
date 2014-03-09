# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  class Configuration < ActiveRecord::Base
    belongs_to :default_locality, class_name: 'Cms::Locality',
      foreign_key: :default_locality_id

    validates :name, presence: true, :if => :persisted?
    validates :default_locality_id, presence: {message: "must have a selection"}, :if => :persisted?
  end
end
