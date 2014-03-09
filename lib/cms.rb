# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require "cms/engine"

module Cms

  def self.components
    @components ||= COMPONENTS.freeze
  end

  def self.page_components
    @page_components ||= components.select { |c| c.cms_page }.freeze
  end

end
