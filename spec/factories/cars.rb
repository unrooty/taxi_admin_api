FactoryBot.define do

  factory :car do
    brand 'Audi'
    car_model 'A8'
    reg_number { generate :reg_number }
    color 'Black'
    style 'Sedan'
  end
end
