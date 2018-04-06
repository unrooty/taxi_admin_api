# frozen_string_literal: true

module Account
  class ResetPassword < Trailblazer::Operation
    step :find_user
    failure :user_not_found!

    step :reset_password

    private

    def find_user(options, params:, **)
      options[:model] = User[reset_password_token: params[:reset_password_token]]
    end

    def user_not_found!(options, **)
      options[:errors] = {
        message: 'Account not found!',
        status: 404
      }
    end

    def reset_password(_options, model:, params:, **)
      model.update(password: params['password'],
                   password_confirmation: params['password_confirmation'])
    end
  end
end
