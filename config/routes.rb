TaskManager::Application.routes.draw do
  root "projects#index"  
  resources :projects, except: [:show]
  resources :tasks, except: [:show] do
    member do
      post 'done'
      post 'priority'
    end
  end


end
