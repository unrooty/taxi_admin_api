# frozen_string_literal: true

class User
  module Activation
    class Activate < Trailblazer::Operation
      step Model(User, :[])

      step Policy::Pundit(UsersPolicy, :can_manage?)

      step :activate!
      failure :user_already_activated!

      private

      def activate!(_options, model:, **)
        model.update(active: true) unless model.active
      end

      def user_already_activated!(options, *)
        options[:errors] = {
          message: 'User already activated!',
          status: 422
        }
      end
    end

    class Deactivate < Trailblazer::Operation
      step Model(User, :[])

      step Policy::Pundit(UsersPolicy, :can_manage?)

      step Wrap(SequelTransaction) {
        success :remove_from_orders!

        success :remove_from_cars!

        step :deactivate!
      }

      private

      def remove_tokens(_options, model:, **)
        model.refresh_token&.delete
      end

      def remove_from_cars!(_options, model:, **)
        model.car&.update_all(user_id: nil)
      end

      def deactivate!(_options, model:, **)
        model.update(active: false) if model.active
      end

      def user_already_deactivated!(options, *)
        options[:errors] = {
          message: 'User already deactivated!',
          status: 422
        }
      end

      def send_email(_options, model:, **)
        UserMailer.account_deactivated(model).deliver
      end
    end
  end
end
