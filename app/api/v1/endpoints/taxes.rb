# frozen_string_literal: true

module V1
  module Endpoints
    class Taxes < Grape::API
      resource :taxes do
        desc '',
             entity: V1::Entities::Tax,
             nickname: 'getAllTaxes',
             detail: 'Returns an array of taxes.',
             summary: 'Get all taxes.',
             http_codes: DocHelper.index_codes('taxes')

        get '/' do
          p 'hello'
          result = Tax::Index.call(params: params,
                                          current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::Tax
          end
        end

        desc '',
             entity: V1::Entities::Tax,
             nickname: 'createNewTax',
             detail: 'Creates new tax.',
             summary: 'Create new tax.',
             http_codes: DocHelper.create_codes('tax')

        params do
          requires :tax, type: Hash do
            requires :name, type: String,
                            desc: "Tax's name",
                            allow_blank: false
            requires :basic_cost, type: BigDecimal,
                                  desc: "Tax's basic cost.",
                                  allow_blank: false
            requires :cost_per_km, type: BigDecimal,
                                   desc: "Tax's cost per kilometer.",
                                   allow_blank: false
          end
        end

        post '/' do
          result = Tax::Create.call(params: params,
                                           current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::Tax
          end

          handle_invalid(result) do
            error!(@contract.errors, 422)
          end
        end

        desc '',
             entity: V1::Entities::Tax,
             nickname: 'getOneTax',
             detail: 'Returns information about tax.',
             summary: 'Get one tax by id.',
             http_codes: DocHelper.show_codes('tax')

        get ':id' do
          result = Tax::Show.call(params: params,
                                         current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::Tax
          end
        end

        desc '',
             entity: V1::Entities::Tax,
             nickname: 'updateExistingTax',
             detail: 'Updates existing tax.',
             summary: 'Update tax.',
             http_codes: DocHelper.update_codes('tax')

        params do
          requires :car, type: Hash do
            requires :name, type: String,
                            desc: "Tax's name",
                            allow_blank: false
            requires :basic_cost, type: BigDecimal,
                                  desc: "Tax's basic cost.",
                                  allow_blank: false,
                                  min_length: 0
            requires :cost_per_km, type: BigDecimal,
                                   desc: "Tax's cost per kilometer.",
                                   allow_blank: false,
                                   min_length: 0
          end
        end

        patch ':id' do
          result = Tax::Update.call(params: params,
                                           current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::Tax
          end

          handle_invalid(result) do
            error!(@contract.errors, 422)
          end
        end

        desc '',
             entity: V1::Entities::Tax,
             nickname: 'deleteTax',
             detail: 'Deletes an existing tax. Returns default tax if exists.',
             summary: 'Delete tax.',
             http_codes:
                 DocHelper.delete_codes('tax',
                                        {
                                          code: 409,
                                          message: 'Conflict in tax deletion.',
                                          model: V1::Entities::ClientError
                                        },
                                        code: 200,
                                        message: 'Tax deleted. Presented default tax.',
                                        model: V1::Entities::Tax)

        delete ':id' do
          result = Tax::Delete.call(params: params,
                                           current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::Tax
          end

          handle_invalid(result) do
            error!(@contract.errors, 422)
          end
        end

        desc '',
             entity: V1::Entities::Tax,
             nickname: 'setDefaultTax',
             detail: 'Request for setting default tax.',
             summary: 'Set default tax.',
             http_codes: [
               {
                 code: 201,
                 message: 'Tax set as default.',
                 model: V1::Entities::Tax
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
                 message: 'Tax with id not found.',
                 model: V1::Entities::ClientError
               },
               {
                 code: 500,
                 message: 'Server Error.',
                 model: V1::Entities::ApiError
               }
             ]

        params do
          requires :id, type: Integer,
                        desc: 'Identifier of tax for setting as default.',
                        allow_blank: true
        end

        post '/set_default' do
          result = Tax::SetDefault.call(params: params,
                                               current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::Tax
          end
        end
      end
    end
  end
end
