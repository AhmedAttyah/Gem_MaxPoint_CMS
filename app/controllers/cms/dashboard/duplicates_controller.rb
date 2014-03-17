require_dependency "cms/application_controller"

module Cms
  class Dashboard::DuplicatesController < ApplicationController
    def new
      @locality = Locality.where(["id != ?", current_locality.id])
    end

    def create
      system "rake copy_locality:copy_pages LOCALITY=#{params[:to_locality]},#{current_locality.id} &"
      flash[:notice] = "Your pages are being copied in the background.  Please wait at least 5 minutes to view them."
      redirect_to dashboard_pages_url
    end

    private
    def copy_params
      params.require(:duplicate).permit(
        :to_locality
      )
    end
  end
end
