# frozen_string_literal: true

class User
  class Create < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(User, :new)

      step Policy::Pundit(UsersPolicy, :can_manage?)

      step self::Contract::Build(constant: User::Contract::Create)
    end

    step Nested(Present)

    success :bring_number_to_right_format

    step self::Contract::Validate(key: :user)

    step Wrap(SequelTransaction) {
      step :add_confirm_token_to_user

      success :bind_user_to_manager_affiliate

      step self::Contract::Persist()

      step :send_welcome_email
    }

    private

    def bring_number_to_right_format(_options, params:, **)
      params['user']['phone'].gsub!(/[^\d]/, '')
    end

    def add_confirm_token_to_user(_options, model:, **)
      model.confirmation_token = SecureRandom.urlsafe_base64.to_s
    end

    def bind_user_to_manager_affiliate(_options, model:, current_user:, **)
      model.affiliate_id = current_user.affiliate_id if current_user.manager?
    end

    def send_welcome_email(_options, model:, **)
      UserMailer.confirmation_email(model).deliver
      model.update(confirmation_sent_at: Time.now)
    end
  end
end
