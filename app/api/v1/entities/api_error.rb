module V1
  module Entities
    class ApiError < Grape::Entity
      expose :error_code, documentation: { type: Integer, desc: ' status code' }
      expose :message, documentation: { type: String, desc: ' error message' }
      expose :note, documentation: { type: String, desc: ' additional information' }
    end
  end
end
