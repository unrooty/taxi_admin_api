# frozen_string_literal: true

class Order
  class Index < Trailblazer::Operation
    step Policy::Pundit(OrdersPolicy, :can_work_with_order?)

    class New < Trailblazer::Operation
      step :model!

      private

      def model!(options, *)
        options[:model] = Order.where(order_status: 'New').all
      end
    end

    class InProgress < Trailblazer::Operation
      step :model!

      private

      def model!(options, *)
        options[:model] = Order.where(order_status: 'In progress').all
      end
    end

    class Completed < Trailblazer::Operation
      step :model!

      private

      def model!(options, *)
        options[:model] = Order.where(order_status: 'Completed').all
      end
    end
  end
end
