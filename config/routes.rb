TrlnArgon::Engine.routes.draw do
  scope module: 'trln_argon' do
    resources :healthchecks, path: '/health', action: :index
  end

  get 'catalog/suggest/:category', to: 'catalog#suggest'
  get 'trln/suggest/:category', to: 'trln#suggest'
  get 'trln/advanced', to: 'trln#advanced_search'
  get 'catalog_count_only', to: 'catalog#count_only', as: 'catalog_count_only'
  get 'trln_count_only', to: 'trln#count_only', as: 'trln_count_only'
  get 'hathitrust/:oclc_numbers', to: 'hathitrust#show', as: 'hathitrust'
  get 'internet_archive/:internet_archive_ids', to: 'internet_archive#show', as: 'internet_archive'

  # redirects for blacklight_advanced_search plugin former URLs
  get '/advanced', to: redirect('catalog/advanced')
  get '/advanced_trln', to: redirect('trln/advanced')

  get 'logs' => 'catalog#logs', as: 'logs'
end
