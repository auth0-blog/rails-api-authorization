Rails.application.routes.draw do
  
  resources :users do 
    resources :expenses
    resources :reports, only: [:show] do
      collection do
        get 'submitted'
        get 'review'
      end
    end
  end
end
