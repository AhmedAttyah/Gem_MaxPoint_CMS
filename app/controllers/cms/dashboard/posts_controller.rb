# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class Dashboard::PostsController < ApplicationController
    before_filter :verify_admin!, only: %w(destroy)

    def index
      @posts = Post.in(current_locality).all
    end

    def new
      @post = Post.new(locality: current_locality, author: current_user)
    end

    def edit
      @post = Post.in(current_locality).find(params[:id])
    end

    def create
      @post = Post.new(post_params.merge(locality_id: current_locality.id))

      if @post.save
        flash[:success] = "Post saved."
        redirect_to edit_dashboard_post_url(@post)
      else
        render action: "new"
      end
    end

    def update
      @post = Post.find(params[:id])

      if @post.update_attributes post_params
        flash[:success] = "Post updated."
        redirect_to edit_dashboard_post_url(@post)
      else
        render action: "edit"
      end
    end

    def destroy
      @post = Post.find(params[:id])
      @post.destroy

      redirect_to(dashboard_posts_url)
    end

    private
    def post_params
      params.require(:post).permit(
        :title, :slug,
        :description, :body,
        :author_id, :category_id,
        :published_at, :published, :tag_names
      )
    end
  end
end
