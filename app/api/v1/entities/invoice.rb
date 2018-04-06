# frozen_string_literal: true

module V1
  module Entities
    class Invoice < Grape::Entity
      expose :distance, documentation:
          {
            type: BigDecimal,
            desk: ' distance of trip',
            required: true
          }
      expose :total_price, documentation:
          {
            type: BigDecimal,
            desk: ' total price of trip'
          }
      expose :payed_amount, documentation:
          {
            type: BigDecimal,
            desk: ' money that client payed',
            required: true
          }
      expose :indebtedness, documentation:
          {
            type: BigDecimal,
            desk: " client's indebtedness"
          }
      expose :invoice_status, documentation:
          {
            type: String,
            desc: " status of invoice, can be 'Paid', 'Unpaid', 'Partially paid'"
          }
      expose :order_id, documentation:
          {
            type: Integer,
            desc: " id of invoice's order"
          }
    end
  end
end
