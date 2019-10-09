Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post :authentication, to: 'authentication#create'
      scope module: 'vcp' do
        resources :wellness_plans, only: [:index, :show]
      end
    end
  end
end
