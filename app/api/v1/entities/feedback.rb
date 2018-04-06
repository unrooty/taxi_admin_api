# frozen_string_literal: true

module V1
  module Entities
    class Feedback < Grape::Entity
      expose :email, documentation: {
        type: String,
        desc: " user's email for answer"
      }

      expose :message, documentation: {
        type: String,
        desc: " user's message"
      }

      expose :name, documentation: {
        type: String,
        desc: " user's name"
      }
    end
  end
end
