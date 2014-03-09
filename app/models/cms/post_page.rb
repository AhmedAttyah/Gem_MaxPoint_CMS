module Cms
  class PostPage < Page

    attr_accessor :post

    def title
      return post.title if post
      super
    end

    def meta_description
      return post.meta_description if post
      super
    end

    def meta_keywords
      return post.meta_keywords if post
      super
    end

  end
end
