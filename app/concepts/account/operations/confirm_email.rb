# frozen_string_literal: true

module Account
  class ConfirmEmail < Trailblazer::Operation
    step Wrap(SequelTransaction) {
      step :model!
      failure :user_not_found!

      step :confirm_email
    }

    private

    def model!(options, params:, **)
      options[:model] = User[confirmation_token: params[:confirmation_token]]
    end

    def token_invalid(options, *)
      options[:errors] = {
        message: 'Confirmation token invalid.',
        status: 422
      }
    end

    def confirm_email(options, *)
      options[:model].update(active: true,
                             confirmed_at: Time.now,
                             confirmation_token: nil)
    end

    def send_welcome_email(options, *)
      UserMailer.welcome_email(options[:model]).deliver
    end
  end
end
