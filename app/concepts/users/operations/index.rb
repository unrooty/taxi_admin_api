# frozen_string_literal: true

class User
  class Index < Trailblazer::Operation
    step Policy::Pundit(CarsPolicy, :can_work_with_car?)

    step :manager_model!

    success :admin_model!

    private

    def manager_model!(options, *)
      options[:model] = User.where(affiliate_id:
                                       options[:current_user].affiliate_id)
    end

    def admin_model!(options, current_user:, **)
      options[:model] = User.all if current_user.role == 'Admin'
    end
  end
end
