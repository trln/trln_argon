Rails.application.routes.draw do
  scope module: 'trln_argon' do
    resources :healthchecks, path: '/health', action: :index
  end

  mount BlacklightAdvancedSearch::Engine => '/'

  get 'advanced_trln' => 'advanced_trln#index', as: 'advanced_trln'
end
