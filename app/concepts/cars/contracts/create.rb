class Car
  module Contract
    class Create < Reform::Form
      include ActiveModel::Validations
      property :brand
      property :car_model
      property :reg_number
      property :color
      property :style
      property :user_id
      property :affiliate_id

      validates :reg_number, uniqueness: true

    end
  end
end
