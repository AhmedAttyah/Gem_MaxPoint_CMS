require_dependency "cms/application_controller"

module Cms
  class CommentsController < Cms::PagesController

    def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(comment_params)
      @page = Page.in(current_locality).post_page
      @page.post = @post
      if @comment.save
        flash[:success] = "Comment added!"
        redirect_to "#{request.scheme}://#{request.host}#{":#{request.port}" if request.port}#{@post.locality_full_path}"
      else
        flash.now[:error] = "Comment could not be added."
        render :route
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:email, :name, :website, :body, :parent_id)
    end

  end
end
