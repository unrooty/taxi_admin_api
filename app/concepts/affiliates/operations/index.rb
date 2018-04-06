# frozen_string_literal: true

class Affiliate
  class Index < Trailblazer::Operation
    step :model!

    step Policy::Pundit(AffiliatesPolicy, :user_admin?)

    private

    def model!(options, **)
      options[:model] = Affiliate.order(Sequel.asc(:name)).all
    end
  end
end
