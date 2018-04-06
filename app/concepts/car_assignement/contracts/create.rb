# frozen_string_literal: true

class CarAssignment
  module Contract
    class Create < Reform::Form
      property :car_id
      property :order_id
    end
  end
end
