# frozen_string_literal: true

# Phone Is Length Validator for Grape
module V1::Validators
  class PhoneLengthValidator < Grape::Validations::Base
    def validate_param!(attr_name, params)
      params[attr_name]&.gsub!(/[^\d]/, '')
      unless params[attr_name]&.length == @option
        raise Grape::Exceptions::Validation,
              params: [@scope.full_name(attr_name)],
              message: "must be #{@option} characters long"
      end
    end
  end
end
