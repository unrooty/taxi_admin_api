# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:attr) { { payed_amount: 8, indebtedness: 0 } }
  let(:invoice) { create(:invoice) }
  context 'supports CRUD:' do
    it 'can be created' do
      expect(invoice).to exist
    end

    it 'can be read' do
      expect(Invoice[invoice.id]).to eq invoice
    end

    it 'can be updated' do
      invoice.update(attr)
      expect([invoice.payed_amount, invoice.indebtedness]).to eq [
        attr[:payed_amount],
        attr[:indebtedness]
      ]
    end

    it 'can be deleted' do
      expect(invoice.delete).not_to exist
    end
  end

  context 'supports database validations: ' do
    it 'is invalid without distance' do
      expect { create(:invoice, distance: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without total price' do
      expect { create(:invoice, total_price: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without payed amount' do
      expect { create(:invoice, payed_amount: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without invoice status' do
      expect { create(:invoice, invoice_status: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without indebtedness' do
      expect { create(:invoice, indebtedness: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without order id' do
      expect { create(:invoice, order_id: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid with negative distance' do
      expect { create(:invoice, distance: -12) }.to raise_error(
        Sequel::CheckConstraintViolation
      )
    end

    it 'is invalid with negative total price' do
      expect { create(:invoice, total_price: -10) }.to raise_error(
        Sequel::CheckConstraintViolation
      )
    end

    it 'is invalid with negative payed amount' do
      expect { create(:invoice, payed_amount: -8) }.to raise_error(
        Sequel::CheckConstraintViolation
      )
    end

    it 'is invalid with negative indebtedness' do
      expect { create(:invoice, indebtedness: -2) }.to raise_error(
        Sequel::CheckConstraintViolation
      )
    end
  end

  context 'status' do
    it 'can be only "Paid", "Unpaid" and "Partially paid"' do
      expect(create(:invoice, order_id: 1,
                              invoice_status: 'Paid')).to be_truthy

      expect(create(:invoice, order_id: 2,
                              invoice_status: 'Unpaid')).to be_truthy

      expect(create(:invoice, order_id: 3,
                              invoice_status: 'Partially paid')).to be_truthy

      expect do
        create(:invoice, order_id: 4,
                         invoice_status: 'Semi-Paid')
      end .to raise_error(
        Sequel::CheckConstraintViolation
      )
    end

    it 'is "Unpaid" by default' do
      expect(invoice.invoice_status).to eq 'Unpaid'
    end
  end

  context 'has methods to check status: ' do
    it 'unpaid?' do
      expect(invoice.unpaid?).to eq true
    end

    it 'partially_paid?' do
      invoice.update(invoice_status: 'Partially paid')
      expect(invoice.partially_paid?).to eq true
    end

    it 'paid?' do
      invoice.update(invoice_status: 'Paid')
      expect(invoice.paid?).to eq true
    end
  end

  context 'has association' do
    it 'one to one with orders' do
      is_expected.to have_one_to_one(:order, key: :id)
    end
  end
end
