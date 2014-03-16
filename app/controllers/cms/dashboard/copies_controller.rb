require_dependency "cms/application_controller"

module Cms
  class Dashboard::CopiesController < ApplicationController
    def new
      @locality = Locality.where(["id != ?", current_locality.id])
    end

    def create
      self.main
    end

    private
    def copy_params
      params.require(:copy).permit(
        :to_locality
      )
    end
  end
end
