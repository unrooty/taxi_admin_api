# frozen_string_literal: true

module V1
  module Entities
    class Auth < Grape::Entity
      expose :access_token, documentation:
      {
        type: String,
        desc: " user's access token, expires in 30 minutes from create"
      }
      expose :refresh_token, documentation:
          {
            type: String,
            desc: " user's refresh token, stored in db,
                     unique, attached to user and user's device"
          }
      expose :expires_in, documentation:
          {
            type: DateTime,
            desc: ' expiration time of access token'
          }
    end
  end
end
