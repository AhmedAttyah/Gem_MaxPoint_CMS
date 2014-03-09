# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  class ApplicationController < ActionController::Base
    include SharedApplicationControllerMethods

    before_filter :authorize!

    helper_method :current_user, :current_locality, :conf

    private

    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end

    def sign_in(user)
      session[:user_id] = user.id
    end

    def sign_out
      reset_session
    end

    def authorize!
      unless current_user
        flash[:alert] = "You need to be logged in for that."
        redirect_to new_dashboard_session_url
        return
      end
    end

    def verify_admin!
      unless current_user && current_user.admin?
        flash[:alert] = "You do not have permission to access that resource."
        redirect_to :back
        return
      end
    end

  end
end
