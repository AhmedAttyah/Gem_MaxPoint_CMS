# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  module RoutingHelper

    def cms_category_path(category)
      url_for(category: category.slug)
    end

    def cms_tag_path(tag)
      url_for(tag: tag.slug)
    end

    def cms_year_path(year)
      url_for(year: year)
    end

    def cms_year_month_path(year, month)
      url_for(year: year, month: month)
    end

    def cms_blog_search_path
      Cms::BlogPage.in(current_locality).first.locality_path
    end

    def cms_comments_path(post)
      cms.comments_path(post_id: post.id)
    end

    def cms_link_to(*args, &block)
      if block_given?
        location = args[0]
        options  = args[1] || {}

        return cms_link_to(capture(&block), location, options)
      end

      name     = args[0]
      location = args[1]
      options  = args[2] || {}

      if location.is_a? Cms::Link
        options = options.merge(target: location.target)
        location = location.locality_location
      else
        options = options.merge(target: location[0].send("#{location[1]}_target"))
        location = location[0].send("#{location[1]}_location")
      end
      link_to name, location, options
    end
  end
end
