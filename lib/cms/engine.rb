# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

require 'activerecord-postgres-hstore/coder'
require 'bootstrap-sass'
require 'bootstrap-wysihtml5-rails'
require 'select2-rails'
require 'haml-rails'
require 'presents'
require 'kaminari'

module Cms
  class Engine < ::Rails::Engine
    isolate_namespace Cms
    initializer 'cms.components' do |app|
      ActiveSupport.on_load :after_initialize do
        Dir[Rails.root.join("app", "components", "*.rb")].each {|f| require f}
        Cms.const_set :COMPONENTS, Cms::Component.descendants.freeze
        Cms.const_set :COMPONENT_NAMES, Cms::COMPONENTS.map(&:name).freeze
      end
    end
    initializer 'cms.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper Cms::RenderingHelper
        helper Cms::NavigationHelper
        helper Cms::RoutingHelper
        ::ApplicationController.send :include, SharedApplicationControllerMethods
        ::ApplicationController.send :helper_method, :current_locality, :conf
      end
    end
  end
end
