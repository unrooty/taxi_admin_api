module V1
  module Endpoints
    class Account < Grape::API
      resource :account do
        params do
          requires :account, type: Hash do
            requires :email, allow_blank: false
            requires :password, allow_blank: false
            requires :device_id, allow_blank: false
          end
        end
        post '/login' do
          result = ::Account::Login.call(params: params)
          handle_successful(result) do
            present @model, with: V1::Entities::Auth
          end

          handle_invalid(result) do
            error!(@contract.errors, 422)
          end
        end
      end
    end
  end
end
