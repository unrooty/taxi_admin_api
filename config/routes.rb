Rails.application.routes.draw do
  mount V1::Endpoints::Base, at: '/api/v1'

  mount GrapeSwaggerRails::Engine => '/docs'

  root to: 'home#index'
end
