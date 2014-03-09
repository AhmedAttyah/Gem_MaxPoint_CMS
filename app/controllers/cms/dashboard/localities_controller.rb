# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class Dashboard::LocalitiesController < ApplicationController
    before_filter :verify_admin!

    def index
      @localities = Locality.alphabetical
    end

    def new
      @locality = Locality.new
    end

    def create
      @locality = Locality.new locality_params
      if @locality.save
        flash[:success] = 'Saved locality.'
        redirect_to dashboard_localities_url
      else
        render :new
      end
    end

    def edit
      @locality = Locality.find(params[:id])
    end

    def update
      @locality = Locality.find(params[:id])
      if @locality.update_attributes locality_params
        flash[:success] = "Locality updated."
        redirect_to dashboard_localities_url
      else
        render :edit
      end
    end

    def destroy
      @locality = Locality.find(params[:id])
      @locality.destroy

      redirect_to(dashboard_localities_url)
    end

    private

    def locality_params
      params.require(:locality).permit(:slug, :name)
    end
  end
end
