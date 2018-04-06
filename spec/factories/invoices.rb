# frozen_string_literal: true

FactoryBot.define do

  factory :invoice do
    distance 10
    total_price 8
    payed_amount 0
    indebtedness 8
    order_id 1
  end
end
