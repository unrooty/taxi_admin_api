module V1
  module Endpoints
    class Accounts < Grape::API
      resource :account do

        params do
          requires :account, type: Hash do
            requires :email, allow_blank: false
            requires :password, allow_blank: false
            requires :device_id, allow_blank: false
          end
        end

        post '/login' do
          handle(::Account::Login.call(params: params)) do
            present @model, with: V1::Entities::Auth
          end
        end
      end
    end
  end
end
