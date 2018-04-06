
# frozen_string_literal: true

class CarAssignment
  class Create < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(OpenStruct, :new)

      step self::Contract::Build(constant:
                                     CarAssignment::Contract::Create)
    end

    step Nested(Present)

    step self::Contract::Validate()

    step Wrap(SequelTransaction) {
      step :find_car
      failure :car_not_found!, fail_fast: true

      step :car_not_assigned?
      failure :car_already_assigned!, fail_fast: true

      step :find_order
      failure :order_not_found!, fail_fast: true

      step :order_has_no_car?
      failure :order_already_has_car!

      step :update_order_status

      step :assign_car_to_order

      step :update_car_status

      success :send_car_assignment_email_to_user
    }

    step :model!

    private

    def find_car(_options, params:, **)
      @car = Car[params['car_id']]
    end

    def car_not_found!(options, params:, **)
      options[:errors] = {
        message: "Car with id: #{params['car_id']} not found.",
        status: 404
      }
    end

    def car_not_assigned?(*)
      !@car.ordered?
    end

    def car_already_assigned!(options, *)
      options[:errors] = {
        message: 'Car already assigned to order!',
        status: 422
      }
    end

    def find_order(_options, params:, **)
      @order = Order[params['order_id']]
    end

    def order_not_found!(options, params:, **)
      options[:errors] = {
        message: "Order with id: #{params['order_id']} not found.",
        status: 404
      }
    end

    def order_has_no_car?(*)
      !@order.car_id
    end

    def order_already_has_car!(options, *)
      options[:errors] = {
        message: 'Order already has car!',
        status: 422
      }
    end

    def update_order_status(*)
      @order.update(order_status: 'In progress')
    end

    def assign_car_to_order(*)
      @order.update(car_id: @car.id)
    end

    def send_car_assignment_email_to_user(*)
      UserMailer.car_assignment_mail(@order.user, @car) if @order.user_id
    end

    def update_car_status(*)
      @car.update(car_status: 'Ordered')
    end

    def model!(options, *)
      options[:model] = @order
    end
  end
end
