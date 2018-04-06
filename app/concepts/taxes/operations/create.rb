# frozen_string_literal: true

class Tax
  class Create < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Tax, :new)

      step Policy::Pundit(TaxesPolicy, :can_manage?)

      step self::Contract::Build(constant: Tax::Contract::Create)
    end

    step Nested(Present)

    step self::Contract::Validate(key: :tax)

    step self::Contract::Persist()
  end
end
