# frozen_string_literal: true

class Car
  class Delete < Trailblazer::Operation
    step Model(Car, :[])

    step Policy::Pundit(CarsPolicy, :can_delete_car?)
    failure :forbidden!

    step Wrap(SequelTransaction) {
      success :remove_from_orders!

      step :delete!
    }

    private

    def remove_from_orders!(_options, model:, **)
      model.orders.update_all(car_id: nil) unless model.orders.empty?
    end

    def delete!(_options, model:, **)
      model.destroy
    end

    def forbidden!(options, *)
      options[:errors] = { message: 'Forbidden', status: 403 }
    end
  end
end
