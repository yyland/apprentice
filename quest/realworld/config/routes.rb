Rails.application.routes.draw do
  namespace :api do
    post 'articles', to: 'articles#create'
    get 'articles/:slug', to: 'articles#show'
    put 'articles/:slug', to: 'articles#update'
    delete 'articles/:slug', to: 'articles#destroy'
  end
end
