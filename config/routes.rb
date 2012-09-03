Rezets::Application.routes.draw do

  resources :recipes, :only => [:index]
  resources :categories, :except => [:index]
  resources :ingredients, :only => [:index]
  
  resources :users, :except => [:show] do
    get :rookies, :on => :collection
    resources :recipes, :except => [:show] do
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

  match '/users/:id' => redirect('/%{id}')
  match '/users/:user_id/recipes/:id' => redirect('/%{user_id}/%{id}')

  get ':id', :to => 'users#show', :as => :user
  put ':id', :to => 'users#update'
  get ':user_id/:id', :to => 'recipes#show', :as => :user_recipe
  put ':user_id/:id', :to => 'recipes#update'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
