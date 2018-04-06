# frozen_string_literal: true

module Account
  module Contract
    class Login < Reform::Form
      property :email
      property :password
      property :device_id
    end
  end
end
