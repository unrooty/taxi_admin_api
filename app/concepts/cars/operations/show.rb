# frozen_string_literal: true

class Car
  class Show < Trailblazer::Operation
    step Model(Car, :[])

    step Policy::Pundit(CarsPolicy, :can_show_car?)
  end
end
