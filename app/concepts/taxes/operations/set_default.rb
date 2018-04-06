# frozen_string_literal: true

class Tax
  class SetDefault < Trailblazer::Operation
    step Model(OpenStruct, :new)

    step self::Contract::Build(constant: Tax::Contract::SetDefault)

    step self::Contract::Validate()

    step Wrap(SequelTransaction) {
      step :tax_exists?
      failure :tax_not_exists!

      step :tax_not_default?
      failure :tax_already_default!

      step :set_previous_default_tax_as_not_default

      step :set_chosen_tax_as_default
    }

    private

    def tax_exists?(_options, params:, **)
      @tax = Tax[params[:id]]
    end

    def tax_not_exists!(_options, params:, **)
      options[:errors] = {
        message: "Tax with id: #{params[:id]} not exists!",
        status: 404
      }
    end

    def tax_not_default?(_options, *)
      !@tax.by_default
    end

    def tax_already_default!(options, *)
      options[:errors] = {
        message: 'Tax has already been chosen as default.',
        stastus: 422
      }
    end

    def set_previous_default_tax_as_not_default(_options, *)
      Tax.where(by_default: true).last.update(by_default: false)
    end

    def set_chosen_tax_as_default(options, **)
      options[:model] = @tax.update(by_default: true)
    end
  end
end
