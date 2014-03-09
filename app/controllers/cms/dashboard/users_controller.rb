# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class Dashboard::UsersController < ApplicationController
    before_filter :verify_admin!, except: %w(edit update)

    def index
      @users = User.order('created_at desc')
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new new_user_params
      if @user.save
        flash[:success] = 'Saved user.'
        redirect_to dashboard_users_url
      else
        render :new
      end
    end

    def edit
      @user = User.find(params[:id])

      verify_admin! if !current_user.admin? && @user != current_user
    end

    def update
      @user = User.find(params[:id])

      if !current_user.admin? && @user != current_user
        verify_admin!
        return
      end

      if params.has_key? :current_password
        if @user.authenticate(params[:current_password])
          if @user.update_attributes password_params
            flash[:success] = "Password updated"
            redirect_to edit_dashboard_user_url
          else
            render :edit
          end
        else
          flash.now[:alert] = "Current password must match."
          render :edit
        end
      else
        if current_user.update_attributes user_params
          flash[:success] = "Account updated."
          redirect_to edit_dashboard_user_url
        else
          render :edit
        end
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy

      redirect_to(dashboard_users_url)
    end

    private

    def new_user_params
      params.require(:user).permit(:email, :name, :admin, :password, :password_confirmation)
    end

    def user_params
      params.require(:user).permit(:email, :name, :admin)
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
