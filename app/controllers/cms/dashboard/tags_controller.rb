# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class Dashboard::TagsController < ApplicationController

    def index
      @tags = Tag.all
    end

  end
end
