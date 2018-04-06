# frozen_string_literal: true
GrapeSwaggerRails.options.app_name = 'Taxi Station API'
GrapeSwaggerRails.options.api_key_name = 'access-token'
GrapeSwaggerRails.options.api_key_type = 'header'
GrapeSwaggerRails.options.url = '/api/v1/docs.json'
GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end
