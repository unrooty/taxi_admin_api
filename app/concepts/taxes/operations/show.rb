# frozen_string_literal: true

class Tax
  class Show < Trailblazer::Operation
    step Policy::Pundit(TaxesPolicy, :can_manage?)

    step :model!

    private

    def model!(options, params:, **)
      options[:model] = Tax[params[:id]]
    end
  end
end
