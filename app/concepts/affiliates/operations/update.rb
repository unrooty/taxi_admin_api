# frozen_string_literal: true

class Affiliate
  class Update < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Affiliate, :[])

      step Policy::Pundit(AffiliatesPolicy, :user_admin?)

      step self::Contract::Build(constant: Affiliate::Contract::Create)
    end

    step Nested(Present)

    step self::Contract::Validate(key: :affiliate)

    step self::Contract::Persist()
  end
end
