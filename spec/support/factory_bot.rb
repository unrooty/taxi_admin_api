# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
FactoryBot.define do
  to_create(&:save)
end

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@ex.com"
  end
  sequence :reg_number do
    "AA-#{rand(1000...10_000)}-#{rand(1..7)}"
  end
end
