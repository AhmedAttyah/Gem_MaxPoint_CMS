# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class Dashboard::LinksController < ApplicationController
    before_filter :verify_admin!, except: %w(index edit update)

    def index
      @links = Link.in(current_locality).all.sort{|a, b| a.location <=> b.location }
    end

    def new
      @link = Link.new
    end

    def create
      @link = Link.new(link_params)
      if @link.save
        flash[:success] = "Link created."
        redirect_to dashboard_links_url
      else
        flash.now[:error] = "Please fix the errors below."
        render :new
      end
    end

    def edit
      @link = Link.find(params[:id])
    end

    def update
      @link = Link.find(params[:id])
      if @link.update_attributes(link_params)
        flash[:success] = "Link updated."
        redirect_to dashboard_links_url
      else
        flash.now[:error] = "Please fix the errors below."
        render :new
      end
    end

    def destroy
      @link = Link.find(params[:id])
      @link.destroy
      flash[:success] = "Link removed."
      redirect_to dashboard_links_url
    end

    private

    def link_params
      params.require(:link).permit(
        :text, :name, :parent_id, :page_id, :external_url, :alt, :title, :position,
        :summary, :description
      ).merge(locality_id: current_locality.id)
    end
  end
end
