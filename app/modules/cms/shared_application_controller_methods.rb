# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

module Cms
  module SharedApplicationControllerMethods

    private

    def current_locality
      @current_locality ||= find_locality || conf.default_locality ||
        Cms::Locality.order('id').first || Cms::Locality.new
    end

    def find_locality
      if params.has_key? :_locality
        slug = params[:_locality]
      elsif params.has_key? :path
        slug = params[:path].split('/', 2)[0]
      else
        return conf.default_locality
      end
      Locality.find_by_slug(slug)
    end

    def conf
      @conf ||= (Cms::Configuration.last || Cms::Configuration.create)
    end

    def default_url_options
      options = super
      options[:_locality] = current_locality.slug
      options
    end
  end
end
