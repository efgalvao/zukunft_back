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
    resources :transferences, module: 'users', only: %i[index create]

    scope module: 'account' do
      resources :accounts do
        get '/current_account_report', to: 'account_reports#current_account_report'
        get '/account_reports', to: 'account_reports#account_reports'
        get '/account_report', to: 'account_reports#account_report'

        resources :transactions, only: %i[index create update]
      end

      get '/cards', to: 'accounts#cards'
      get '/brokers', to: 'accounts#brokers'
    end

    scope module: 'investments', path: '/investments' do
      get '/', to: 'investments#index', as: 'investments'

      resources :stocks, controller: 'stock/stocks', except: %i[edit new]
    end

    post 'dividends', to: 'investments/stock/dividends#create'
    post 'prices', to: 'investments/prices#create'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
