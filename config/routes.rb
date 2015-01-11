TaskManager::Application.routes.draw do
  root "projects#index"  
  resources :projects, except: [:show, :new]
  resources :tasks, except: [:show, :new]
end
