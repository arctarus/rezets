Rezets::Application.routes.draw do

  resources :recipes, :only => [:index]
  resources :categories, :except => [:index]
  resources :ingredients, :only => [:index]
  
  resources :users do
    get :rookies, :on => :collection
    resources :recipes do
      member do
        get :print
        get :email
        post :email_send
        put :like
        put :unlike
      end
      resources :ingredients
      resources :comments
    end
    resources :categories, :only => [:show]
    resources :follows, :only => [:index, :create, :destroy]
    resources :likes, :only => [:index]
    resource :update_password, :only => [:new, :create]
  end

  resources :invitations, :only => [:index, :new, :create]
  resource :session, :path_names => { :new => "login", :destroy => "logout" }
  resources :feedback, :only => [:new, :create]
 
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"

  match "/users/new/:token" => "users#new"
  match "/about"    => "home#about",    :as => :about
  match "/search"   => "home#search",   :as => :search
  match "/feed"     => "home#feed",     :as => :feed

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
