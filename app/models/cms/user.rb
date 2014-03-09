# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  class User < ActiveRecord::Base
    has_secure_password

    validates :email, uniqueness: {
      case_insensitive: true,
      allow_blank: false,
      allow_nil: false
    }

  end
end
