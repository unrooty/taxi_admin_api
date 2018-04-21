# frozen_string_literal: true

module V1
  module Endpoints
    class Affiliates < Grape::API
      resource :affiliates do
        desc '',
             entity: V1::Entities::Affiliate,
             nickname: 'getAllAffiliates',
             detail: 'Returns an array of affiliates.',
             summary: 'Get all affiliates.',
             http_codes: DocHelper.index_codes('affiliates')

        get '/' do
          handle(Affiliate::Index.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Affiliate
          end
        end

        desc '',
             entity: V1::Entities::Affiliate,
             nickname: 'createNewAffiliate',
             detail: 'Creates new affiliate.',
             summary: 'Create new affiliate.',
             http_codes: DocHelper.create_codes('affiliate')

        params do
          requires :affiliate, type: Hash do
            requires :name, type: String,
                            desc: "Affiliate's name.",
                            allow_blank: false
            requires :address, type: String,
                               desc: "Affiliate's address.",
                               allow_blank: false
          end
        end

        post '/' do
          handle(Affiliate::Create.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Affiliate
          end
        end

        desc '',
             entity: V1::Entities::User,
             nickname: 'getAffiliateWorkers',
             detail: 'Returns an array of workers of affiliate.',
             summary: 'Get workers of affiliate.',
             http_codes: DocHelper.show_codes('affiliate')

        get ':id/workers' do
          handle(Affiliate::Workers.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::User
          end
        end

        desc '',
             entity: V1::Entities::Affiliate,
             nickname: 'getOneAffiliate',
             detail: 'Returns information about affiliate.',
             summary: 'Get one affiliate by id.',
             http_codes: DocHelper.show_codes('affiliate')

        get ':id' do
          handle(Affiliate::Show.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Affiliate
          end
        end

        desc '',
             entity: V1::Entities::Affiliate,
             nickname: 'updateExistingAffiliate',
             detail: 'Updates existing affiliate.',
             summary: 'Update affiliate.',
             http_codes: DocHelper.update_codes('affiliate')

        params do
          requires :affiliate, type: Hash do
            requires :name, type: String,
                            desc: "Affiliate's name.",
                            allow_blank: false
            requires :address, type: String,
                               desc: "Affiliate's address.",
                               allow_blank: false
          end
        end

        patch ':id' do
          handle(Affiliate::Update.call(params: params, current_user: current_user)) do
            present @model, with: V1::Entities::Affiliate
          end
        end

        desc '',
             entity: V1::Entities::Affiliate,
             nickname: 'deleteAffiliate',
             detail: 'Deletes an existing affiliate.',
             summary: 'Delete affiliate.',
             http_codes: DocHelper.delete_codes('affiliate')

        delete ':id' do
          handle(Affiliate::Delete.call(params: params, current_user: current_user)) do
            status :no_content
          end
        end
      end
    end
  end
end
