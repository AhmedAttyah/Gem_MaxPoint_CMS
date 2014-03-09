# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  module Dashboard::ComponentHelper
    def sorted_form_components(builder)
      builder.object.components.any? ? builder.object.components.sorted : []
    end
  end
end
