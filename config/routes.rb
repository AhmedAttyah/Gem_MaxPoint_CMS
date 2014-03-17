# This file is subject to the terms and conditions defined in
# file 'LICENSE.rdoc', which is part of this source code package.

Cms::Engine.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  scope path: "(:_locality)" do
    namespace :dashboard do
      resource :session, only: %w(new create) do
        get "/destroy" => "sessions#destroy"
      end

      resources :users
      resources :localities, except: %w(show)
      resources :pages, except: %w(show)
      resources :links, path: '/navigation', except: %w(show)
      resource :configuration, only: %w(edit update)
      resource :duplicates, only: %w(new create)

      resources :posts, except: :show
      resources :comments, except: %w(show new create)
      resources :categories, except: :show
      resources :tags, only: :index

      root to: "static#dashboard"
    end

    resources :comments, only: :create

    match '*path' => 'pages#route', format: false, via: [:get, :put, :patch, :post, :delete]
    root to: "pages#route"
  end
end
