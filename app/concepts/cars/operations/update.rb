# frozen_string_literal: true

class Car
  class Update < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Car, :[])

      step Policy::Pundit(CarsPolicy, :can_work_with_car?)

      step self::Contract::Build(constant: Car::Contract::Create)
    end

    step Nested(Present)

    step Wrap(SequelTransaction) {
      step :user_exists?
      failure :user_not_exist!, fail_fast: true

      step :user_has_no_car?
      failure  :user_already_has_car!

      step self::Contract::Validate(key: :car)

      step self::Contract::Persist()
    }

    private

    def user_exists?(_options, params:, **)
      @user = User[params['car']['user_id']]
    end

    def user_not_exist!(options, params:, **)
      options[:errors] = {
        message: "User with id: #{params['car']['user_id']} not exists!",
        status: 404
      }
    end

    def user_has_no_car?(_options, **)
      @user.car
    end

    def user_already_has_car!(options, params:, **)
      options[:errors] = {
        message: "User with id: #{params['car']['user_id']} already has car!",
        status: 422
      }
    end
  end
end
