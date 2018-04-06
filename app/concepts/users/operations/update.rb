# frozen_string_literal: true

class User
  class Update < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(User, :[])

      step Policy::Pundit(UsersPolicy, :can_manage?)

      step self::Contract::Build(constant: User::Contract::Create)
    end

    step Nested(Present)

    success :bring_number_to_right_format

    step self::Contract::Validate(key: :user)

    step self::Contract::Persist()

    private

    def bring_number_to_right_format(_options, params:, **)
      params['user']['phone'].gsub!(/[^\d]/, '')
    end
  end
end
