module V1
  module Entities
    class AccessError < Grape::Entity
      expose :error, documentation: { type: String,
                                      desc: ' error message',
                                      required: true }
    end
  end
end
