# frozen_string_literal: true

class Order
  class Update < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Order, :[])

      step Policy::Pundit(OrdersPolicy, :can_work_with_order?)

      step self::Contract::Build(constant: Order::Contract::Create)
    end

    step Nested(Present)

    success :bring_number_to_right_format

    step self::Contract::Validate(key: :order)

    step self::Contract::Persist()

    private

    def bring_number_to_right_format(_options, params:, **)
      params['order']['client_phone'].gsub!(/[^\d]/, '')
    end
  end
end
