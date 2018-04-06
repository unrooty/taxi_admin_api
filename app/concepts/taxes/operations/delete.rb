# frozen_string_literal: true

class Tax
  class Delete < Trailblazer::Operation
    step Model(Tax, :[])

    step Policy::Pundit(TaxesPolicy, :can_manage?)

    step :delete!
    failure :tax_default!

    private

    def delete!(_options, model:, **)
      return model.destroy if Order.where(tax_id: model.id).empty? && !model.by_default
      model.update(deleted: true) unless model.by_default
    end

    def tax_default!(options, *)
      options[:errors] = { message: error_message,
                           status: 409 }
    end

    def error_message
      'Tax set as default. Set another order as default and try again!'
    end
  end
end
