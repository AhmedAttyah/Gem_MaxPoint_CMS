require_dependency "cms/application_controller"

module Cms
  class Dashboard::DuplicatesController < ApplicationController
    def new
      @locality = Locality.where(["id != ?", current_locality.id])
    end

    def create
      Duplicate.main(params['to_locality'],current_locality.id)
      flash[:success] = "Successfully Copied pages."
      redirect_to dashboard_pages_url
    end

    private
    def copy_params
      params.require(:copy).permit(
        :to_locality
      )
    end
  end
end
