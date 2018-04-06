# frozen_string_literal: true

module Account
  class Update < Trailblazer::Operation
    step :add_current_user_id_to_params

    step Model(User, :[])

    step :current_password_valid?
    failure :current_password_invalid!, fail_fast: true

    step :account_active?
    failure :account_deactivated!

    step self::Contract::Build(constant: Account::Contract::Update)

    success :bring_number_to_right_format

    step self::Contract::Validate(key: :user)

    step self::Contract::Persist()

    private

    def add_current_user_id_to_params(_options, params:, current_user:, **)
      params.merge!(id: current_user.id)
    end

    def current_password_valid?(_options, model:, params:, **)
      model.valid_password?(params['user']['current_password'])
    end

    def current_password_invalid!(options, *)
      options[:errors] = {
        message: 'Current password invalid.',
        status: 422
      }
    end

    def account_active?(_options, current_user:, **)
      current_user.active
    end

    def account_deactivated!(options, *)
      options[:errors] = {
        message: 'Account deactivated!',
        status: 401
      }
    end

    def bring_number_to_right_format(_options, params:, **)
      params['user']['phone'].gsub!(/[^\d]/, '')
    end
  end
end
