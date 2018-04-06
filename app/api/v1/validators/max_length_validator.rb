# frozen_string_literal: true
# Max Length Validator for Grape
module V1::Validators
  class MaxLengthValidator < Grape::Validations::Base
    def validate_param!(attr_name, params)
      if params[attr_name]&.length > @option
        raise Grape::Exceptions::Validation,
              params: [@scope.full_name(attr_name)],
              message: "must be at the maximum #{@option} characters long"
      end
    end
  end
end
