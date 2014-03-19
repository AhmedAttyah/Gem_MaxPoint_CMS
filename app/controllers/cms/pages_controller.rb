# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require_dependency "cms/application_controller"

module Cms
  class PagesController < ::ApplicationController

    skip_before_filter :authorize!

    def route
      @locality = current_locality
      slugs = request.path.split('/')
      slugs = slugs.reject{|v| v.blank?}
      slugs.shift if slugs.first == current_locality.slug

      @post, index_slugs = post_for(slugs)
      if @post.present?
        verify! pages_for(index_slugs)
        @page = Page.in(current_locality).post_page
        raise "No post page defined" unless @page
        @page.post = @post
      else
        pages = pages_for(slugs)
        verify! pages
        @page = pages.first
        if @page.class == Cms::BlogPage
          if params[:term]
            @posts = Post.search(params[:term])
          elsif params[:category]
            category = Category.in(current_locality).where(slug: params[:category]).first
            raise ActiveRecord::RecordNotFound unless category
            @posts = category.posts
          elsif params[:tag]
            tag = Tag.in(current_locality).where(slug: params[:tag]).first
            raise ActiveRecord::RecordNotFound unless tag
            @posts = tag.posts
          elsif params[:month]
            @posts = Post.where("concat(extract(year from published_at), '-', extract(month from published_at)) = ?", "#{params[:year]}-#{params[:month]}")
          elsif params[:year]
            @posts = Post.where('extract(year from published_at) = ?', params[:year])
          else
            @posts = Post.scoped
          end
          @posts = @posts.in(current_locality).published.published_after.
            ordered.page(params[:page]).per(10)
        else
          redirect_to '/' if not @page.published == true
        end
      end
    end


    private

    def post_for(slugs)
      date_slugs = slugs[-4..-2]
      return [nil, nil] if date_slugs.nil?
      date_values = date_slugs.map(&:to_i)
      return [nil, nil] if date_values.all?{|v| v == 0}
      date = Time.new(*date_values).midnight
      post = Post.published.published_after.published_on(date).
        with_slug(slugs[-1]).first
      [post, slugs[0..-5]]
    end

    def pages_for(slugs)
      pages = slugs.reverse.inject(Array.new) { |pages, slug|
        pages << Page.in(current_locality).find_by_slug!(slug)
        pages
      } << Page.in(current_locality).home_page
      pages
    end

    def verify!(pages)
      pages.each_with_index do |page, idx|
        next unless page.parent
        raise ActiveRecord::RecordNotFound unless pages[idx + 1] == page.parent
      end
      true
    end
  end
end
