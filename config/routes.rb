Rails.application.routes.draw do

  root "divisions#index"
  resources :d, controller: "divisions", only: [:index, :show] do
    resources :teams, only: [:create]
    resources :players, only: [:create]
  end

end
