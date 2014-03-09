# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class Dashboard::SessionsController < ApplicationController
    layout 'cms/unauthenticated'

    skip_before_filter :authorize!

    def create
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        sign_in user
        flash[:success] = "You are now signed in."
        redirect_to dashboard_root_url
      else
        flash.now[:error] = "The email or password you entered is incorrect."
        render :new
      end
    end

    def destroy
      sign_out
      flash[:success] = "You are now signed out."
      redirect_to new_dashboard_session_url
    end

  end
end
