TrlnArgon::Engine.routes.draw do
  scope module: 'trln_argon' do
    resources :healthchecks, path: '/health', action: :index
  end

  mount BlacklightAdvancedSearch::Engine => '/'
  mount Blacklight::Citeproc::Engine => '/'

  get 'advanced_trln' => 'advanced_trln#index', as: 'advanced_trln'
  get 'suggest/:category', to: 'suggest#show'
  get 'catalog_count_only', to: 'catalog#count_only', as: 'catalog_count_only'
  get 'trln_count_only', to: 'trln#count_only', as: 'trln_count_only'
  get 'hathitrust/:oclc_numbers', to: 'hathitrust#show', as: 'hathitrust'
  get 'internet_archive/:internet_archive_ids', to: 'internet_archive#show', as: 'internet_archive'

end
