Rails.application.routes.draw do
  root to: 'home#index'

  get 'home/index'

  get 'account/bookmarks'

  get 'account/bookmarks'

  get 'account/reviews'

  delete 'account/:id', to: 'account#destroy', as: :account_destroy

	get 'account/logout'

  resources :users do
		resources :bookmarks
  end

  resources :reviews do 
		resources :comments, only: :create
  end
end
