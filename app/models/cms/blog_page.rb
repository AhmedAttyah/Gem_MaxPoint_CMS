module Cms
  class BlogPage < Page
    def post_path(post)
      @post_path ||= [path, post.path].join('/')
    end

    def locality_post_path(post)
      @locality_post_path ||= "/#{locality.slug}#{post_path(post)}"
    end
  end
end
