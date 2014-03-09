# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class Dashboard::CategoriesController < ApplicationController
    before_filter :verify_admin!, only: %w(destroy)

    def index
      @categories = Category.in(current_locality).all
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params.merge(locality))
      if @category.save
        flash[:success] = "Category saved."
        redirect_to dashboard_categories_url
      else
        flash.now[:error] = "Please fix any errors below."
        render :new
      end
    end

    def edit
      @category = Category.in(current_locality).find(params[:id])
    end

    def update
      @category = Category.in(current_locality).find(params[:id])
      if @category.update_attributes(category_params)
        flash[:success] = "Category updated."
        redirect_to dashboard_categories_url
      else
        flash.now[:error] = "Please fix any errors below."
        render :edit
      end
    end

    def destroy
      @category = Category.in(current_locality).find(params[:id])
      @category.destroy
      flash[:success] = "Category removed."
      redirect_to dashboard_categories_url
    end

    private

    def category_params
      params.require(:category).permit(:name)
    end

    def locality
      {locality_id: current_locality.id}
    end
  end
end
