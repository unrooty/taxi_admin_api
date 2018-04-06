# frozen_string_literal: true

class Car
  class Index < Trailblazer::Operation
    step Policy::Pundit(CarsPolicy, :can_work_with_car?)

    step :model!

    private

    def model!(options, *)
      if options[:current_user].admin?
        options[:model] = Car.all
      else
        options[:model] = Car.where(affiliate_id:
                                        options[:current_user].affiliate_id).all
      end
    end
  end
end
