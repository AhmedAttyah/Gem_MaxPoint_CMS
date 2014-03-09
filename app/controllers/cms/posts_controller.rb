# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class PostsController < ::ApplicationController
    include SharedApplicationControllerMethods
    helper_method :current_locality

    before_filter :find_post, only: [:show, :comment]

    def index
      @posts = Post.ordered.published.published_after.
        page(params[:page]).per(20)
      render "posts/index"
    end

    def category
      category = Category.in(current_locality).where(slug: params[:slug]).first
      @posts = category.posts.in(current_locality).
        page(params[:page]).per(20)
      render "posts/category"
    end

    def tag
      tag = Tag.in(current_locality).where(slug: params[:slug]).first
      @posts = tag.posts.in(current_locality).
        page(params[:page]).per(20)
      render "posts/tag"
    end

    def show
      @comment = @post.comments.build
      render "posts/show"
    end

    def comment
      @comment = @post.comments.build(comment_params)
      if @comment.save
        flash[:success] = "Comment added!"
        redirect_to post_url
      else
        flash.now[:error] = "Comment could not be added."
        render :show
      end
    end

    private

    def find_post
      date = Time.new(params[:year], params[:month], params[:day]).midnight
      @post = Post.published_on(date).with_slug(params[:slug]).first
      raise ActiveRecord::RecordNotFound unless @post
    end

    def comment_params
      params.require(:comment).permit(:email, :name, :website, :body, :parent_id)
    end

  end
end
