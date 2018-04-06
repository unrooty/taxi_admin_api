# frozen_string_literal: true

class Car
  class Update < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Car, :[])

      step Policy::Pundit(CarsPolicy, :can_update_car?)

      step self::Contract::Build(constant: Car::Contract::Create)
    end

    step Nested(Present)

    step Wrap(SequelTransaction) {
      step :user_exists?
      failure :user_not_exist!, fail_fast: true

      step :user_driver?
      failure :user_not_driver!, fail_fast: true

      step :user_has_no_car?
      failure :user_already_has_car!, fail_fast: true

      step :car_and_driver_affiliate_id_equals?
      failure :affiliate_id_not_equal!, fail_fast: true

      step self::Contract::Validate(key: :car)

      step self::Contract::Persist()
    }

    private

    def user_exists?(_options, params:, **)
      if params[:car][:user_id]
        @user = User[params['car']['user_id']]
      else
        true
      end
    end

    def user_not_exist!(options, params:, **)
      options[:errors] = {
        message: "User with id: #{params['car']['user_id']} not exists!",
        status: 404
      }
    end

    def user_driver?(*)
      return true unless @user
      @user.driver?
    end

    def user_not_driver!(options, *)
      options[:errors] = {
        message: "User with user_id: #{@user.id} not driver",
        status: 422
      }
    end

    def car_and_driver_affiliate_id_equals?(_options, params:, **)
      return true unless @user
      @user.affiliate_id.equal?(params[:car][:affiliate_id])
    end

    def affiliate_id_not_equal!(options, *)
      options[:errors] = {
        message: 'Car and driver affiliate id must equal',
        status: 422
      }
    end

    def user_has_no_car?(_options, **)
      return true if @user && !@user.car
      return false if @user&.car
      true
    end

    def user_already_has_car!(options, params:, **)
      options[:errors] = {
        message: "User with id: #{params['car']['user_id']} already has car!",
        status: 422
      }
    end
  end
end
