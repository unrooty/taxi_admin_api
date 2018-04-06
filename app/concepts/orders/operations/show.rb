# frozen_string_literal: true

class Order
  class Show < Trailblazer::Operation
    step Model(Order, :[])

    step Policy::Pundit(OrdersPolicy, :can_work_with_order?)
  end
end
