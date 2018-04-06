# frozen_string_literal: true

module Account
  class Login < Trailblazer::Operation

    step Model(OpenStruct, :new)

    step self::Contract::Build(constant: Account::Contract::Login)

    step self::Contract::Validate(key: :account)

    step Wrap(SequelTransaction) {
      step :check_email_existence
      failure :invalid_email!, fail_fast: true

      step :check_password_correctness
      failure :invalid_password!, fail_fast: true

      step :account_active?
      failure :account_deactivated!, fail_fast: true

      step :account_confirmed?
      failure :account_not_confirmed!, fail_fast: true

      step :change_sign_in_info

      step :set_expiration_time

      step :generate_access_token

      step :generate_refresh_token

      step :add_refresh_token_to_db
      failure :database_error!

      step :model!
    }

    private

    def check_email_existence(_options, params:, **)
      @user = User[email: params[:account][:email]]
    end

    def invalid_email!(options, params:, **)
      options[:errors] = {
        message: "Account with email: '#{params[:account][:email]}' does not exists.",
        status: 404
      }
    end

    def check_password_correctness(_options, params:, **)
      @user.valid_password?(params[:account][:password])
    end

    def invalid_password!(options, *)
      options[:errors] = {
        message: 'Password invalid.',
        status: 422
      }
    end

    def account_active?(_options, *)
      @user.active
    end

    def account_deactivated!(options, *)
      options[:errors] = {
        message: "Account with email: '#{@user.email}' deactivated.",
        status: 401
      }
    end

    def account_confirmed?(*)
      return true if @user.confirmed_at
      @user.confirmation_sent_at + 12.hours < Time.now
    end

    def account_not_confirmed!(options, *)
      options[:errors] = {
        message: 'Email not confirmed.',
        status: 403
      }
    end

    def change_sign_in_info(_options, *)
      sign_in_count = @user.sign_in_count + 1
      current_sign_in = Time.now
      last_sign_in = if @user.last_sign_in_at
                       @user.current_sign_in_at
                     else
                       current_sign_in
                     end

      @user.update(current_sign_in_at: current_sign_in,
                   last_sign_in_at: last_sign_in,
                   sign_in_count: sign_in_count)
    end

    def set_expiration_time(_options, *)
      @access_time = Time.now.utc + JsonWebToken::ACCESS_TOKEN_TTL
      @refresh_time = Time.now.utc + JsonWebToken::REFRESH_TOKEN_TTL
    end

    def generate_access_token(_options, **)
      @access_token = JsonWebToken.encode(
        { JsonWebToken::USER_IDENTIFIER => @user.id },
        @access_time.to_i
      )
    end

    def generate_refresh_token(_options, params:, **)
      @refresh_token = JsonWebToken.encode(
        {
          JsonWebToken::USER_IDENTIFIER => { id: @user.id, name: @user.first_name },
          device_id: params[:account][:device_id]
        },
        @refresh_time.to_i
      )
    end

    def add_refresh_token_to_db(_options, params:, **)
      refresh_token = ::RefreshToken[device_id: params[:account][:device_id],
                                   user_id: @user.id]
      if refresh_token
        return refresh_token.update(
          token: Digest::SHA2.hexdigest(@refresh_token),
          expires_in: @refresh_time
        )
      end

      ::RefreshToken.create(
        token: Digest::SHA2.hexdigest(@refresh_token),
        device_id: params[:account][:device_id],
        expires_in: @refresh_time, user_id: @user.id
      )
    end

    def database_error!(options, *)
      options[:errors] = {
        message: 'Token already in use. Please, repeat authorization.',
        status: 500
      }
    end

    def model!(options, *)
      options[:model] = {
        access_token: @access_token,
        refresh_token: @refresh_token,
        expires_in: @access_time
      }
    end
  end
end
