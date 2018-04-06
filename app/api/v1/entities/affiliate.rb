# frozen_string_literal: true

module V1
  module Entities
    class Affiliate < Grape::Entity
      root 'affiliates', 'affiliate'
      expose :id, documentation: {
        type: Integer,
        desc: ' affiliate unique identifier'
      }

      expose :name, documentation: {
        type: String,
        desc: " affiliate's name. unique field",
        required: true
      }

      expose :address, documentation: {
        type: String,
        desc: " affiliates's address",
        required: true
      }
    end
  end
end
