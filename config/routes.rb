Rails.application.routes.draw do
  resources :users do 
    resources :expenses
  end
end
