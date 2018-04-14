# frozen_string_literal: true

# Invoice model class.
class Invoice < Sequel::Model
  one_to_one :order, key: :id

  STATUSES = [
    PAID = 'Paid',
    UNPAID = 'Unpaid',
    PARTIALLY_PAID = 'Partially paid'
  ].freeze

  STATUSES.each do |status|
    define_method "#{status.tr(' ', '_').downcase}?" do
      invoice_status == status
    end
  end
end
