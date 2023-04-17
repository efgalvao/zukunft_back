Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }


  scope 'api/v1' do
    resources :categories, module: 'users'

    scope module: 'account' do
      resources :accounts
      resources :transactions, only: %i[index create update]

      get '/cards', to: 'accounts#cards'
      get '/brokers', to: 'accounts#brokers'
    end

  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
