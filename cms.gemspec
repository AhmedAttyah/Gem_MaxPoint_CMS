$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "vasari-cms"
  s.version     = Cms::VERSION
  s.authors     = ["Your name"]
  s.email       = ["Your email"]
  s.homepage    = nil
  s.summary     = "Summary of Cms."
  s.description = "Description of Cms."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"
  s.add_dependency "pg"
  s.add_dependency "activerecord-postgres-hstore"
  s.add_dependency "bootstrap-sass", '~> 2.0'
  s.add_dependency "bootstrap-wysihtml5-rails"
  s.add_dependency "select2-rails"
  s.add_dependency "haml-rails"
  s.add_dependency "strong_parameters"
  s.add_dependency "presents"
  s.add_dependency "kaminari"
  s.add_dependency "bcrypt-ruby", '~> 3.0.0'
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "dragonfly", '~> 0.9.15'
  s.add_dependency "ckeditor", '~> 4.0.4'
end
