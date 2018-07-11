Rails.application.routes.draw do
  scope module: 'trln_argon' do
    resources :healthchecks, path: '/health', action: :index
  end
  mount BlacklightAdvancedSearch::Engine => '/'
end
