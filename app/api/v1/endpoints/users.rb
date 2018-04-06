# frozen_string_literal: true

module V1
  module Endpoints
    class Users < Grape::API
      resource :users do
        desc '',
             entity: V1::Entities::User,
             nickname: 'getAllUsers',
             detail: 'Returns an array of users.',
             summary: 'Get all users.',
             http_codes: DocHelper.index_codes('users')

        get '/' do
          result = User::Index.call(params: params,
                                           current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::User
          end
        end

        desc '',
             entity: V1::Entities::User,
             nickname: 'createNewUser',
             detail: 'Creates new user.',
             summary: 'Create new user.',
             http_codes: DocHelper.create_codes('user')

        params do
          requires :user, type: Hash do
            optional :first_name, type: String,
                                  desc: "User's first name.",
                                  allow_blank: false

            optional :last_name, type: String,
                                 desc: "User's last name.",
                                 allow_blank: false

            requires :role, type: String,
                            desc: "User's role. 'Client' by default.
                                   Must be 'Admin', 'Client', 'Dispatcher', 'Driver',
                                   'Manager' or 'Accountant'",
                            values: %w[Admin Client Dispatcher Driver Manager Accountant],
                            default: 'Client'

            requires :phone, type: String,
                             desc: "User's phone number.",
                             phone_length: 9, allow_blank: false

            requires :email, type: String,
                             desc: "User's email. Unique field.",
                             regexp: /\A[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+\z/,
                             allow_blank: false

            requires :password, min_length: 8,
                                desc: "User's password. Must be confirmed",
                                type: String,
                                allow_blank: false

            requires :password_confirmation, type: String,
                                             desc: 'Password confirmation.',
                                             allow_blank: false

            optional :affiliate_id, type: Integer,
                                    desc: 'Id of affiliate that user attached to.'

            optional :city, type: String,
                            desc: "User's city."

            optional :address, type: String,
                               desc: "User's address.",
                               allow_blank: false
            optional :language, type: String,
                                desc: "Language of user's interface. Default: Russian",
                                default: 'Russian'
          end
        end

        post '/' do
          result = User::Create.call(params: params,
                                            current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::User
          end

          handle_invalid(result) do
            error!(@contract.errors, 422)
          end
        end

        desc '',
             entity: V1::Entities::User,
             nickname: 'getOneUser',
             detail: 'Returns information about user.',
             summary: 'Get one user by id.',
             http_codes: DocHelper.show_codes('user')

        get ':id' do
          result = User::Show.call(params: params,
                                          current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::User
          end
        end

        desc '',
             entity: V1::Entities::User,
             nickname: 'activateUser',
             detail: 'Set "active" to true.',
             summary: 'Activate user.',
             http_codes:
                 [
                   {
                     code: 200,
                     message: 'User activated!'
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
                     message: 'User not found.',
                     model: V1::Entities::ClientError
                   },
                   {
                     code: 422,
                     message: 'User already activated.',
                     model: V1::Entities::ClientError
                   },
                   {
                     code: 500,
                     message: 'Server Error',
                     model: V1::Entities::ApiError
                   }
                 ]

        patch ':id/activate' do
          result = User::Activate.call(params: params,
                                              current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::User
          end

          handle_invalid(result)
        end

        desc '',
             entity: V1::Entities::User,
             nickname: 'deactivateUser',
             detail: 'Set "active" to false.',
             summary: 'Deactivate user.',
             http_codes:
                 [
                   {
                     code: 200,
                     message: 'User deactivated!'
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
                     message: 'User not found.',
                     model: V1::Entities::ClientError
                   },
                   {
                     code: 422,
                     message: 'User already deactivated.',
                     model: V1::Entities::ClientError
                   },
                   {
                     code: 500,
                     message: 'Server Error',
                     model: V1::Entities::ApiError
                   }
                 ]

        patch ':id/deactivate' do
          result = User::Deactivate.call(params: params,
                                                current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::User
          end

          handle_invalid(result)
        end

        desc '',
             entity: V1::Entities::User,
             nickname: 'updateExistingUser',
             detail: 'Updates existing user.',
             summary: 'Update user.',
             http_codes: DocHelper.update_codes('user')

        params do
          requires :user, type: Hash do
            optional :first_name, type: String,
                                  desc: "User's first name.",
                                  allow_blank: false

            optional :last_name, type: String,
                                 desc: "User's last name.",
                                 allow_blank: false

            requires :role, type: String,
                            desc: "User's role. 'Client' by default.
                                   Must be 'Admin', 'Client', 'Dispatcher', 'Driver',
                                   'Manager' or 'Accountant'",
                            values: %w[Admin Client Dispatcher Driver Manager Accountant],
                            default: 'Client'

            requires :phone, type: String,
                             desc: "User's phone number.",
                             phone_length: 9, allow_blank: false

            requires :email, type: String,
                             desc: "User's email. Unique field.",
                             regexp: /\A[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+\z/,
                             allow_blank: false

            requires :password, min_length: 8,
                                desc: "User's password. Must be confirmed",
                                type: String,
                                allow_blank: false

            requires :password_confirmation, type: String,
                                             desc: 'Password confirmation.',
                                             allow_blank: false

            optional :affiliate_id, type: Integer,
                                    desc: 'Id of affiliate that user attached to.'

            optional :city, type: String,
                            desc: "User's city."

            optional :address, type: String,
                               desc: "User's address.",
                               allow_blank: false
            optional :language, type: String,
                                desc: "Language of user's interface. Default: Russian",
                                default: 'Russian'
          end
        end

        patch ':id' do
          result = User::Update.call(params: params,
                                            current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::User
          end

          handle_invalid(result) do
            error!(@contract.errors, 422)
          end
        end

        desc '',
             entity: V1::Entities::User,
             nickname: 'deleteUser',
             detail: 'Deletes an existing user.',
             summary: 'Delete user.',
             http_codes: DocHelper.delete_codes('user')

        delete ':id' do
          result = User::Delete.call(params: params,
                                            current_user: current_user)
          handle_successful(result) do
            status :no_content
          end
        end
      end
    end
  end
end
