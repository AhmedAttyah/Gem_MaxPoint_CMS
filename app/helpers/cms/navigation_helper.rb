# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  module NavigationHelper
    def navigation(name)
      conditions = {name: name.to_s, locality_id: current_locality.id}
      link  = Link.where(conditions).first
      link  = Link.new(conditions) if link.nil?
      yield link if block_given?
      link
    end

    def localities
      Cms::Locality.all
    end

    def tags
      Cms::Tag.in(current_locality).all
    end

    def categories
      Cms::Category.in(current_locality).all
    end

    def years
      Cms::Post.in(current_locality).pluck('DISTINCT extract(year from published_at)').sort { |x,y| y <=> x }
    end

    def months_by_year
      months = Cms::Post.in(current_locality).pluck("DISTINCT concat(extract(year from published_at), '|', extract(month from published_at))")
      months = months.map{|m| m.split('|').map(&:to_i)}
      months.sort.inject({}) {|hash, m| hash[m[0]] ||= [] ; hash[m[0]] << m[1]; hash[m[0]].sort!; hash}
    end

    def related_posts(post)
      return [] unless post.category
      post.category.posts.order("published_at DESC").published_after.published - Array(post)
    end
  end
end
