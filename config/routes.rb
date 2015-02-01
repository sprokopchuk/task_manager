TaskManager::Application.routes.draw do
  root "projects#index"  
	devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations', passwords: 'passwords'}  
  resources :projects, except: [:show]
  resources :tasks, except: [:show] do
    member do
      post 'done'
      post 'priority'
    end
  end


end
