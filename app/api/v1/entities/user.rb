# frozen_string_literal: true

module V1
  module Entities
    class User < Grape::Entity
      root 'users', 'user'
      expose :id, documentation:
          {
            type: Integer,
            desc: ' unique user identifier'
          }
      expose :first_name, documentation:
          {
            type: String,
            desc: " user's first name"
          }
      expose :last_name, documentation:
          {
            type: String,
            desc: " user's last name"
          }
      expose :phone, documentation:
          {
            type: String,
            desc: " user's phone number, must be 9 digits long",
            required: true
          }
      expose :email, documentation:
          {
            type: String,
            desc: " user's email, must be unique",
            required: true
          }
      expose :address, documentation:
          {
            type: String,
            desc: " user's address"
          }
      expose :city, documentation:
          {
            type: String,
            desc: " user's city"
          }
      expose :affiliate_id, documentation:
          {
            type: Integer,
            desc: ' id of affiliate that user assigned to'
          }
      expose :role, documentation:
          {
            type: String,
            desc: " user's role, 'Client' by default,
                     Must be 'Admin', 'Client', 'Dispatcher', 'Driver',
                     'Manager' or 'Accountant'"
          }
      expose :language, documentation:
          {
            type: String,
            desc: " language of user, 'Russian' by default"
          }
      expose :active, documentation:
          {
            type: 'Boolean',
            desc: ' true if account active'
          }
      expose :confirmed_at, documentation:
          {
            type: DateTime,
            desc: ' DateTime when user confirmed email, nil if email not confirmed'
          }, expose_nil: false

      expose :last_sign_in_at, documentation:
          {
            type: DateTime,
            desc: ' DateTime when user signed in last time'
          }, expose_nil: false
      expose :current_sign_in_at, documentation:
          {
            type: DateTime,
            desc: ' DateTime when user signed in for current "session"'
          }, expose_nil: false
      expose :sign_in_count, documentation:
          {
            type: Integer,
            desc: " user's sign in count"
          }, expose_nil: false
      expose :confirmation_token, documentation:
          {
            type: String,
            desc: ' confirmation token'
          }, expose_nil: false
      expose :activation_token, documentation:
          {
            type: String,
            decs: ' activation token for deactivated accounts'
          }, expose_nil: false
    end
  end
end
