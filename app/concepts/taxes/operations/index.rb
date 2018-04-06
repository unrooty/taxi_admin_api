# frozen_string_literal: true

class Tax
  class Index < Trailblazer::Operation
    step :model!

    step Policy::Pundit(TaxesPolicy, :index?)

    private

    def model!(options, *)
      options[:model] = Tax.where(deleted: false).all
    end
  end
end
