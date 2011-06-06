Rezets::Application.routes.draw do
  
  resources :recipes
  resources :categories, :except => [:index]
  
  resources :users do
    get :rookies, :on => :collection
    member do
      get :changepassword
      post :updatepassword
      get :following
      get :likes
      put :follow
      put :unfollow
    end
    resources :categories
    resources :recipes do
      member do
        get :email
        post :email_send
        put :like
        put :unlike
      end
      resources :ingredients
      resources :comments
    end
  end

  resources :invitations
  resource :session, :path_names => { :new => "login", :destroy => "logout" }
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"
  match "/users/new/:token" => "users#new"
  match "/about"    => "home#about",    :as => :about
  match "/feedback" => "home#feedback", :as => :feedback, :via => :get
  match "/feedback" => "home#send_feedback", :as => :feedback, :via => :post
  match "/search"   => "home#search",   :as => :search
  match "/feed"     => "home#feed",     :as => :feed

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
