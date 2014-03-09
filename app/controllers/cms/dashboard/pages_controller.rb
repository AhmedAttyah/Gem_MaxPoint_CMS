# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class Dashboard::PagesController < ApplicationController
    before_filter :verify_admin!, except: %w(index edit update)

    def index
      @pages = Page.in(current_locality).all.sort{|a,b| a.title.downcase <=> b.title.downcase}
    end

    def new
      @page = Page.new
    end

    def create
      @page = Page.new(page_params.merge(locality_id: current_locality.id))
      if @page.save
        flash[:success] = "Page created."
        if params[:commit] == 'Preview'
          redirect_to @page.locality_path
        else
          redirect_to edit_dashboard_page_url(@page)
        end
      else
        flash.now[:error] = "Please fix the errors below."
        render :new
      end
    end

    def edit
      @page = Page.find(params[:id]).becomes(Cms::Page)
    end

    def update
      @page = Page.find(params[:id])
      if @page.update_attributes(page_params)
        flash[:success] = "Page updated."
        if params[:commit] == 'Preview'
          redirect_to @page.locality_path
        else
          redirect_to edit_dashboard_page_url(@page)
        end
      else
        flash.now[:error] = "Please fix the errors below."
        render :new
      end
    end

    def destroy
      @page = Page.find(params[:id])
      if @page.links.any?
        flash[:alert] = "Page cannot be removed because it is linked to from the navigation."
        redirect_to :back
      elsif @page.pages.any?
        flash[:alert] = "Page cannot be removed because it has dependent pages."
        redirect_to :back
      else
        @page.destroy
        flash[:success] = "Page removed."
        redirect_to dashboard_pages_url
      end
    end

    private

    def page_params
      _params = params.require(:page).permit(
        :_type, :title, :slug, :parent_id, :published,
        :meta_description, :meta_keywords
      )
      components = (params[:page][:components_attributes] || {}).to_hash
      _params.merge(components_attributes: components)
    end

  end
end
