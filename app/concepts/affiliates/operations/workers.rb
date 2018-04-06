# frozen_string_literal: true

class Affiliate
  class Workers < Trailblazer::Operation
    step :model!
    failure :not_found!

    step Policy::Pundit(AffiliatesPolicy, :user_admin?)

    step :find_workers!

    private

    def model!(_options, params:, **)
      @affiliate = Affiliate[params[:id]]
    end

    def not_found!(options, params:, **)
      options['errors'] = {
          message: 'Affiliate with id: #{params[:id]} not found.'
      }
    end

    def find_workers!(options, *)
      options[:model] = User.where(affiliate_id:
                                          @affiliate.id).exclude(role: 'Client').all
    end
  end
end
