# frozen_string_literal: true

require_relative '../validators/min_length_validator'
require_relative '../validators/is_length_validator'
require_relative '../validators/max_length_validator'
require_relative '../validators/phone_length_validator'

module V1
  module Endpoints
    class Base < Grape::API
      helpers ResultHandler,
              Authentication::AuthHelpers,
              DocHelper

      format :json

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        if e.message.include?('is missing')
          error!({
                   error_code: 400, message: 'Some data in body is missed',
                   note: 'Check docs and input correct data.'
                 },
                 400, 'Content_Type' => 'text/error')
        else
          error!({
                   error_code: 422, message: e.message,
                   note: 'Input valid parameters.'
                 },
                 422, 'Content_Type' => 'text/error')
        end
      end

      rescue_from :all do |e|
        error!({
                 error_code: 500, message: e,
                 note: 'Contact the developer to solve the problem.'
               },
               500, 'Content_Type' => 'text/error')
      end
      namespace do
        mount V1::Endpoints::Account
        before { authenticate_user! }
        mount V1::Endpoints::Affiliates
        mount V1::Endpoints::Cars
        mount V1::Endpoints::Taxes
        mount V1::Endpoints::Orders
        mount V1::Endpoints::Users
        mount V1::Endpoints::Invoices
        mount V1::Endpoints::CarAssignment
      end

      add_swagger_documentation \
        info: {
          title: 'Taxi Station API',
          description: DocHelper.swagger_admin_description,
          contact_name: 'Vladislav Volkov (GrSU Yanki Kupaly)',
          contact_email: 'volcharneverfall1996@gmail.com'
        },
        tags: [
          {
            name: 'orders', description:
              'Operations with orders and invoices of orders (specified for working staff.).'
          }
        ],
        host: APP_SETTINGS['url'].remove('https://'),
        models: [
          V1::Entities::Order,
          V1::Entities::Auth
        ],
        mount_path: '/docs',
        base_path: '/api/v1/',
        doc_version: '0.7'
    end
  end
end
