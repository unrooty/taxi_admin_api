# frozen_string_literal: true

class Order
  class Delete < Trailblazer::Operation
    step Model(Order, :[])

    step Policy::Pundit(OrdersPolicy, :can_work_with_order?)

    step Wrap(SequelTransaction) {
      success :update_car_status_to_free!

      step :delete!
    }

    private

    def update_car_status_to_free!(_options, model:, **)
      model.car&.update(car_status: 'Free')
    end

    def delete!(_options, model:, **)
      model.destroy
    end
  end
end
