Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }

  authenticated :user do
    root 'projects#index', as: :authenticated_root
  end

  resources :projects do
    resources :notes
    resources :tasks do
      member do
        # toggle_project_task POST /projects/:project_id/tasks/:id/toggle(.:format) tasks#toggle
        post :toggle
      end
    end
    member do
      patch :complete
      patch :incomplete
    end
    collection do
      get :all
    end
  end

  namespace :api do
    #resources :projects#, only: [:index, :show, :create]
    resources :projects do
      resources :tasks, only: [:index, :show]
    end
  end

  root "home#index"
end
