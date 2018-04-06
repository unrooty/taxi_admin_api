# frozen_string_literal: true

module V1
  module Entities
    class Order < Grape::Entity
      root 'orders', 'order'
      expose :id, documentation: {
        type: Integer,
        desc: ' unique order identifier'
      }

      expose :client_name, documentation: {
        type: 'String',
        desc: ' client first name',
        required: true
      }

      expose :client_phone, documentation: {
        type: 'String',
        desc: ' client phone number',
        required: true
      }

      expose :start_point, documentation: {
        type: 'String',
        desc: ' start point of trip',
        required: true
      }

      expose :end_point, documentation: {
        type: 'String',
        desc: ' end point of trip',
        required: true
      }

      expose :user_id, documentation: {
        type: Integer,
        desc: ' identifier of user that order present to'
      }, expose_nil: false

      expose :tax_id, documentation: {
        type: Integer,
        desc: ' identifier of user that order present to'
      }

      expose :car_id, documentation: {
        type: Integer,
        desc: ' identifier of car that assigned to order'
      }, expose_nil: false
    end
  end
end
