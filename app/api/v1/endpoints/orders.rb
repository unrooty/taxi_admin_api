# frozen_string_literal: true

module V1
  module Endpoints
    class Orders < Grape::API
      resource :orders do
        desc '',
             entity: V1::Entities::Order,
             nickname: 'getAllNewOrders',
             detail: 'Returns an array of new orders.',
             summary: 'Get all new orders.',
             http_codes: DocHelper.index_codes('orders')

        get '/new' do
          handle(Order::Index::New.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Order
          end
        end

        desc '',
             entity: V1::Entities::Order,
             nickname: 'getAllInProgressOrders',
             detail: 'Returns an array of orders that in progress.',
             summary: 'Get all orders that in progress.',
             http_codes: DocHelper.index_codes('orders')

        get '/in_progress' do
          handle(Order::Index::InProgress.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Order
          end
        end

        desc '',
             entity: V1::Entities::Order,
             nickname: 'getAllCompletedOrders',
             detail: 'Returns an array completed of orders.',
             summary: 'Get all completed orders.',
             http_codes: DocHelper.index_codes('orders')

        get '/completed' do
          handle(Order::Index::Completed.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Order
          end
        end

        desc '',
             entity: V1::Entities::Order,
             nickname: 'createNewOrder',
             detail: 'Creates new order.',
             summary: 'Create new order.',
             http_codes: DocHelper.create_codes('order')

        params do
          requires :order, type: Hash do
            requires :client_name, type: String,
                                   desc: 'Client first name.',
                                   allow_blank: false

            requires :client_phone, type: String,
                                    desc: 'Client phone number.',
                                    allow_blank: false,
                                    phone_length: 9

            requires :start_point, type: String,
                                   desc: 'Start point of trip.',
                                   allow_blank: false

            requires :end_point, type: String,
                                 desc: 'End point of trip.',
                                 allow_blank: false
            optional :tax_id, type: Integer,
                              desc: 'Id of tax for order invoice.
                                    Uses id of default tax if empty.'
          end
        end

        post '/' do
          handle(Order::Create.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Order
          end
        end

        desc '',
             entity: V1::Entities::Order,
             nickname: 'getOneOrder',
             detail: 'Returns information about order.',
             summary: 'Get one order by id.',
             http_codes: DocHelper.show_codes('order')

        get ':id' do
          handle(Order::Show.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Order
          end
        end

        desc '',
             entity: V1::Entities::Order,
             nickname: 'updateExistingOrder',
             detail: 'Updates existing order.',
             summary: 'Update order.',
             http_codes: DocHelper.update_codes('order')

        params do
          requires :order, type: Hash do
            requires :client_name, type: String,
                                   desc: 'Client first name.',
                                   allow_blank: false

            requires :client_phone, type: String,
                                    desc: 'Client phone number.',
                                    allow_blank: false,
                                    phone_length: 9

            requires :start_point, type: String,
                                   desc: 'Start point of trip.',
                                   allow_blank: false

            requires :end_point, type: String,
                                 desc: 'End point of trip.',
                                 allow_blank: false
            optional :tax_id, type: Integer,
                              desc: 'Id of tax for order invoice.
                                    Uses id of default tax if empty'
          end
        end

        patch ':id' do
          handle(Order::Update.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Order
          end
        end

        desc '',
             entity: V1::Entities::Order,
             nickname: 'deleteOrder',
             detail: 'Deletes an existing order.',
             summary: 'Delete order.',
             http_codes: DocHelper.delete_codes('order')

        delete ':id' do
          handle(Order::Delete.call(params: params, current_user: current_user)) do
            status :no_content
          end
        end
      end
    end
  end
end
