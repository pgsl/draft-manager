Rails.application.routes.draw do

  root "divisions#index"
  resources :d, controller: "divisions" do
    resources :teams, only: [:create]
    resources :players, only: [:create]
    member do
      get :draft
    end
  end

end
