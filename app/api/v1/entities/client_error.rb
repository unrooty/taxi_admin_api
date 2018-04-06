# frozen_string_literal: true

module V1
  module Entities
    class ClientError < Grape::Entity
      expose :error_code, documentation:
          {
            type: Integer,
            desc: ' error status code'
          }
      expose :message, documentation:
          {
            type: String,
            desc: ' explanation of error'
          }
    end
  end
end
