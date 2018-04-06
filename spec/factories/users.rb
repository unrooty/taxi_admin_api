# frozen_string_literal: true

FactoryBot.define do

  factory :user do
    first_name 'Admin'
    last_name 'Admin'
    email { generate :email }
    password '12345678'
    password_confirmation '12345678'
    phone '123456789'
  end
end
