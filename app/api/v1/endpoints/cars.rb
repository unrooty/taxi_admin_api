# frozen_string_literal: true

module V1
  module Endpoints
    class Cars < Grape::API
      resource :cars do
        desc '',
             entity: V1::Entities::Car,
             nickname: 'getAllCars',
             detail: 'Returns an array of cars.',
             summary: 'Get all cars.',
             http_codes: DocHelper.index_codes('cars')

        get '/' do
          handle(Car::Index.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Car
          end
        end

        desc '',
             entity: V1::Entities::Car,
             nickname: 'createNewCar',
             detail: 'Creates new car.',
             summary: 'Create new car.',
             http_codes: DocHelper.create_codes('car')

        params do
          requires :car, type: Hash do
            requires :brand, type: String,
                             desc: "Car's brand.",
                             max_length: 25,
                             allow_blank: false

            optional :user_id, type: Integer,
                               desc: "Id of car's driver."

            optional :affiliate_id, type: Integer,
                                    desc: 'Id of affiliate that car attached to.'

            requires :car_model, type: String,
                                 desc: "Car's model.",
                                 max_length: 25,
                                 allow_blank: false

            requires :reg_number, regexp: /\A[A-Z]{2}-\d{4}-[1-7]/,
                                  desc: "Car's registration number.
                                            Unique field.
                                            Example format: AA-1111-1.",
                                  type: String,
                                  allow_blank: false

            requires :color, type: String,
                             desc: "Car's color.",
                             max_length: 25,
                             allow_blank: false

            requires :style, type: String,
                             desc: "Car's body style.",
                             max_length: 25,
                             allow_blank: false
          end
        end

        post '/' do
          handle(Car::Create.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Car
          end
        end

        desc '',
             entity: V1::Entities::Car,
             nickname: 'getOneCar',
             detail: 'Returns information about car.',
             summary: 'Get one car by id.',
             http_codes: DocHelper.show_codes('car')

        get ':id' do
          handle(Car::Show.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Car
          end
        end

        desc '',
             entity: V1::Entities::Car,
             nickname: 'updateExistingCar',
             detail: 'Updates existing car.',
             summary: 'Update car.',
             http_codes: DocHelper.update_codes('car')

        params do
          requires :car, type: Hash do
            requires :brand, type: String,
                             desc: "Car's brand.",
                             max_length: 25,
                             allow_blank: false

            optional :user_id, type: Integer,
                               desc: "Id of car's driver.",
                               allow_blank: false

            optional :affiliate_id, type: Integer,
                                    desc: 'Id of affiliate that car attached to.',
                                    allow_blank: false

            requires :car_model, type: String,
                                 desc: "Car's model.",
                                 max_length: 25,
                                 allow_blank: false

            requires :reg_number, regexp: /\A[A-Z]{2}-\d{4}-[1-7]/,
                                  desc: "Car's registration number.
                                            Unique field.
                                            Example format: AA-1111-1.",
                                  type: String,
                                  allow_blank: false

            requires :color, type: String,
                             desc: "Car's color.",
                             max_length: 25,
                             allow_blank: false

            requires :style, type: String,
                             desc: "Car's body style.",
                             max_length: 25,
                             allow_blank: false
          end
        end

        patch ':id' do
          handle(Car::Update.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Car
          end
        end

        desc '',
             entity: V1::Entities::Affiliate,
             nickname: 'deleteCar',
             detail: 'Deletes an existing car.',
             summary: 'Delete car.',
             http_codes: DocHelper.delete_codes('car')

        delete ':id' do
          handle(Car::Delete.call(params: params, current_user: current_user)) do
            status :no_content
          end
        end
      end
    end
  end
end
