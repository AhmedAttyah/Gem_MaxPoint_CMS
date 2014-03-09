# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class Dashboard::CommentsController < ApplicationController
    def index
      @comments = Comment.in(current_locality).descending
    end

    def edit
      @comment = Comment.find(params[:id])
    end

    def update
      @comment = Comment.find(params[:id])
      if @comment.update_attributes(approved_by: current_user)
        flash[:success] = "Approved!"
        redirect_to dashboard_comments_url
      else
        flash[:error] = "There was an error."
        render :edit
      end
    end

    def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy
      flash[:success] = "Comment deleted!"
      redirect_to dashboard_comments_url
    end
  end
end
