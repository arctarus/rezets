Rezets::Application.routes.draw do
  
  resources :recipes
  resources :categories
  
  resources :users do
    member do
      get :changepassword
      post :updatepassword
    end
    resources :categories
    resources :recipes do
      member do
        get :email
        post :email_send
      end
      resources :ingredients
      resources :comments
    end
  end

  resources :invitations
  resource :session, :path_names => { :new => "login", :destroy => "logout" }

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"
  match "/about"    => "home#about",    :as => :about
  match "/feedback" => "home#feedback", :as => :feedback
  match "/search"   => "home#search",   :as => :search
  match "/feed"     => "home#feed",     :as => :feed

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
