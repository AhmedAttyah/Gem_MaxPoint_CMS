# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class Dashboard::ConfigurationsController < ApplicationController
    before_filter :verify_admin!

    def edit
      @configuration = conf
    end

    def update
      @configuration = conf
      if @configuration.update_attributes(configuration_attributes)
        flash[:success] = "Updated configuration."
        redirect_to edit_dashboard_configuration_url
      else
        flash.now[:error] = "Please fix any errors below."
        render :edit
      end
    end

    private

    def configuration_attributes
      params.require(:configuration).permit(:name, :default_locality_id)
    end
  end
end
