# frozen_string_literal: true

class Affiliate
  class Delete < Trailblazer::Operation
    step Model(Affiliate, :[])

    step Policy::Pundit(AffiliatesPolicy, :user_admin?)

    step Wrap(SequelTransaction) {
      success :remove_from_cars!

      step :delete!
    }

    private

    def remove_from_cars!(_options, model:, **)
      Car.where(affiliate_id: model.id).update(affiliate_id: nil)
    end

    def delete!(_options, model:, **)
      model.destroy
    end
  end
end
