# frozen_string_literal: true

class User
  class Delete < Trailblazer::Operation
    step Model(User, :[])

    step Policy::Pundit(UsersPolicy, :can_manage?)

    step Wrap(SequelTransaction) {
      success :remove_from_orders!

      success :remove_from_cars!

      step :delete!
    }

    private

    def remove_from_cars!(_options, model:, **)
      model.car&.update_all(user_id: nil)
    end

    def remove_from_orders!(_options, model:, **)
      model.orders.update_all(user_id: nil) unless model.orders.empty?
    end

    def delete!(_options, model:, **)
      model.destroy
    end
  end
end
