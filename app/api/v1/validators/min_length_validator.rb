# frozen_string_literal: true
# Min Length Validator for Grape
module V1::Validators
  class MinLengthValidator < Grape::Validations::Base
    def validate_param!(attr_name, params)
      if params[attr_name] && params[attr_name].length < @option
        raise Grape::Exceptions::Validation,
              params: [@scope.full_name(attr_name)],
              message: "must be at the minimum #{@option} characters long"
      end
    end
  end
end
