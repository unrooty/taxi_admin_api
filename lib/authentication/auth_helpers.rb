# frozen_string_literal: true

module Authentication
  module AuthHelpers
    def authenticate_user!
      token_present?
      token_expired?
      check_account
    end

    private

    def current_user
      @user
    end

    def token_present?
      if request.headers['Access-Token'].present?
        return @token = request.headers['Access-Token']
      end
      error!('Token absent', 401)
    end

    def token_expired?
      token = JsonWebToken.decode(@token)
      return error!('Token invalid', 401) unless token
      @user = User[token['user']]
    end

    def check_account
      return @user if @user.active
      error!('Account deactivated!', 403)
      if !@user.confirmed_at || (@user.confirmation_sent_at + 12.hours < Time.now)
        error!('Account not confirmed!', 403)
      end
    end
  end
end
