# frozen_string_literal: true

class Affiliate
  class Show < Trailblazer::Operation
    step Model(Affiliate, :[])

    step Policy::Pundit(AffiliatesPolicy, :user_admin?)
  end
end
