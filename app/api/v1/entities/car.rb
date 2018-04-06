# frozen_string_literal: true

module V1
  module Entities
    class Car < Grape::Entity
      root 'cars', 'car'
      expose :id, documentation: {
        type: Integer,
        desc: " car's unique identifier"
      }

      expose :brand, documentation: {
        type: String,
        desc: " car's brand",
        required: true
      }

      expose :car_model, documentation: {
        type: String,
        desc: " car's model",
        required: true
      }

      expose :color, documentation: {
        type: String,
        desc: " car's color",
        required: true
      }

      expose :style, documentation: {
        type: String,
        desc: " car's body style",
        required: true
      }

      expose :reg_number, documentation: {
        type: String,
        desc: " car's registration number, unique field,
                                          example format: AA-1111-1",
        required: true
      }

      expose :affiliate_id, documentation: {
        type: Integer,
        desc: ' id of affiliate that car attached to',
        required: true
      }, expose_nil: false

      expose :user_id, documentation: {
        type: Integer,
        desc: " id of car's driver"
      }, expose_nil: false

      expose :car_status, documentation: {
        type: String,
        desc: " current status of car. Assigns automatically.
                                      Can't be changed by user"
      }
    end
  end
end
