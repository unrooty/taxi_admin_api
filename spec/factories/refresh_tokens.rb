# frozen_string_literal: true

FactoryBot.define do

  factory :refresh_token do
    token SecureRandom.base64.to_s
    expires_in 10.minutes.from_now
    device_id '1'
  end
end
