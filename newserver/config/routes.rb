Newserver::Application.routes.draw do
  resources :goals do
    member do 
      get :adopt
      get :unadopt
    end
    
    resource :notes
    resource :users
    resource :sources
  end
  
  resources :notes do
    member do 
      get :full_text
      put :set_goals
    end
  end

  resources :users do
    collection do 
      get :logout
      post :login
    end
  end
  
  resources :sources
  get 'me', :to => 'users#me', :as => 'me'
  get 'api_key.:format', :to => 'users#api_key', :as => 'api_key'
  get 'verify_api_key.:format', :to => 'users#verify_api_key', :as => 'verify_api_key'
  get 'export', :to => 'goals#export', :as => 'export'
  get 'goals/:id/export', :to => 'goals#download_csv'
  get 'add_comment', :to => 'notes#add_comment'
  get 'add_sub_comment', :to => 'nodes#add_sub_comment'
  get 'promote', :to => 'nodes#promote'
  get 'goals/download_csv', :to => 'goals#download_csv', :as => 'download_csv'
  get 'search', :to => 'search#search', :as => 'search'
  get 'inbox', :to => 'notes#inbox', :as => 'inbox'
  get 'inbox_soruces', :to => 'sources#inbox', :as => 'inbox_sources'
  get 'all_goals', :to => 'goals#all_goals', :as => 'all_goals'
  get 'all_sources', :to => 'sources#all_sources', :as => 'all_sources'
  get 'my_sources', :to => 'sources#my_sources', :as => 'my_sources'
  get 'my_notes', :to => 'notes#my_notes', :as => 'my_notes'
  get 'all_notes', :to => 'notes#all_notes', :as => 'all_notes'
  get 'create_note', :to => 'notes#create', :as => 'create_note'
  get 'js_lib', :to => 'js_lib#js_lib', :as => 'js_lib'
  root :to => 'welcome#welcome'
end
