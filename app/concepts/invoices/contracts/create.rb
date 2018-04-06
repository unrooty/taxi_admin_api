class Invoice
  module Contract
    class Create < Reform::Form
      property :distance
      property :payed_amount

      validates :payed_amount, :distance,
                numericality: { greater_than_or_equal_to: 0 }
    end
  end
end
