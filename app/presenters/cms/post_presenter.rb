# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  class PostPresenter < Presents::BasePresenter
    presents :post

    def author
      if post.author
        post.author.name
      else
        "Unknown"
      end
    end

    def published_at
      post.published_at.present? ? post.published_at.strftime("%l:%M%p on %m/%d/%y %Z") : "No Publish Date"
    end

    def updated_at
      post.updated_at.strftime("%l:%M%p on %m/%d/%y %Z")
    end

    def link_to_publish
      if post.published?
        link_to 'Unpublish',
          dashboard_unpublish_post_path(post),
          title: "Unpublish '#{post.title}'",
          confirm: unpublish_confirmation_message,
          class: 'btn btn-mini btn-danger'
      else
        link_to 'Publish',
          dashboard_publish_post_path(post),
          title: "Publish '#{post.title}'",
          class: 'btn btn-mini'
      end
    end

    def unpublish_confirmation_message
      'Are you sure you want to unpublish the post titled "%s"?' % post.title
    end
  end
end
