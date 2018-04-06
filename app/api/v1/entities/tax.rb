# frozen_string_literal: true

module V1
  module Entities
    class Tax < Grape::Entity
      root 'taxes', 'tax'
      expose :id, documentation:
          {
            type: Integer,
            desc: ' unique tax identifier'
          }

      expose :name, documentation:
          {
            type: String,
            desc: " tax's name",
            required: true
          }

      expose :basic_cost, documentation:
          {
            type: BigDecimal,
            desc: " tax's basic cost",
            required: true
          }
      expose :cost_per_km, documentation:
          {
            type: BigDecimal,
            desc: " tax's cost per kilometer",
            required: true
          }
      expose :by_default, documentation:
          {
            type: 'Boolean',
            desc: ' indicates if tax selected as by default'
          }
    end
  end
end
