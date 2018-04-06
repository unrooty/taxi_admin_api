# frozen_string_literal: true

FactoryBot.define do

  factory :feedback do
    email 'feedbackexample@gmail.com'
    name 'user'
    message 'Some problems with app'
  end
end
