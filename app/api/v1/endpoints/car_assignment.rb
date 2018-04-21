# frozen_string_literal: true

module V1
  module Endpoints
    class CarAssignment < Grape::API
      resource :orders do
        desc '',
             nickname: 'createNewOrder',
             detail: 'Assigns car to order.',
             summary: 'Assign car to order.',
             http_codes: [
               {
                 code: 201,
                 message: 'Car assigned.'
               },
               {
                 code: 400,
                 message: 'One or more params missed.',
                 model: V1::Entities::ClientError
               },
               {
                 code: 401,
                 message: 'No access token present or token invalid.',
                 model: V1::Entities::AccessError
               },
               {
                 code: 403,
                 message: 'Access forbidden.',
                 model: V1::Entities::AccessError
               },
               {
                 code: 404,
                 message: 'Car or order not found.',
                 model: V1::Entities::ClientError
               },
               {
                 code: 422,
                 message: 'Validation error.',
                 model: V1::Entities::ClientError
               },
               {
                 code: 500,
                 message: 'Server Error.',
                 model: V1::Entities::ApiError
               }
             ]

        params do
          requires :car_id, type: Integer,
                            desc: 'Id of car that will be assigned to order.'
        end

        post ':order_id/assign_car' do
          if current_user&.driver?
            handle(CarAssignment::DriverCarAssignment.call(params: params, current_user: current_user)) do
              present @model, with: V1::Entities::Order
            end
          else
            handle(CarAssignment::Create.call(params: params, current_user: current_user)) do
              present @model, with: V1::Entities::Order
            end
          end
        end

        desc '',
             nickname: 'reassignCar',
             detail: 'Reassigns car.',
             summary: 'Reassign car.',
             http_codes: [
               {
                 code: 201,
                 message: 'Car reassigned.'
               },
               {
                 code: 400,
                 message: 'One or more params missed.',
                 model: V1::Entities::ClientError
               },
               {
                 code: 401,
                 message: 'No access token present or token invalid.',
                 model: V1::Entities::AccessError
               },
               {
                 code: 403,
                 message: 'Access forbidden.',
                 model: V1::Entities::AccessError
               },
               {
                 code: 404,
                 message: 'Car or order not found.',
                 model: V1::Entities::ClientError
               },
               {
                 code: 422,
                 message: 'Validation error.',
                 model: V1::Entities::ClientError
               },
               {
                 code: 500,
                 message: 'Server Error.',
                 model: V1::Entities::ApiError
               }
             ]

        params do
          requires :car_id, type: Integer,
                            desc: 'Id of car that will be assigned to order.'
        end

        post ':order_id/reassign_car' do
          handle(CarAssignment::Update.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Order
          end
        end
      end
    end
  end
end
