# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:attr) { { client_phone: '123456790', end_point: 'Brest' } }
  let(:tax) { create(:tax) }
  let(:order) { create(:order, tax_id: tax.id) }

  context 'supports CRUD:' do
    it 'can be created' do
      expect(order).to exist
    end

    it 'can be read' do
      expect(Order[order.id]).to eq order
    end

    it 'can be updated' do
      order.update(attr)
      expect([order.client_phone, order.end_point]).to eq [
        attr[:client_phone],
        attr[:end_point]
      ]
    end

    it 'can be deleted' do
      expect(order.delete).not_to exist
    end
  end

  context 'supports database validations:' do
    it 'is invalid without client name' do
      expect { create(:order, client_name: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without client phone' do
      expect { create(:order, client_phone: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without start point' do
      expect { create(:order, start_point: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without end point' do
      expect { create(:order, end_point: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without order status' do
      expect { create(:order, order_status: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without tax id' do
      expect { create(:order, tax_id: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid with wrong client phone length (must be 9)' do
      # 8
      expect do
        create(:order, client_phone: '12345678',
                       tax_id: tax.id)
      end.to raise_error(Sequel::DatabaseError)
      # 10
      expect do
        create(:order, client_phone: '1234567890',
                       tax_id: tax.id)
      end.to raise_error(Sequel::DatabaseError)
    end
  end

  context 'status' do
    it 'can be only "New", "In progress" and "Completed"' do
      expect(create(:order, tax_id: tax.id,
                            order_status: 'New')).to be_truthy

      expect(create(:order, tax_id: tax.id,
                            order_status: 'In progress')).to be_truthy

      expect(create(:order, tax_id: tax.id,
                            order_status: 'Completed')).to be_truthy

      expect do
        create(:order, tax_id: tax.id,
                       order_status: 'Semi-Completed')
      end .to raise_error(
        Sequel::CheckConstraintViolation
      )
    end

    it 'is "New" by default' do
      expect(order.order_status).to eq 'New'
    end
  end

  context 'has association' do
    it 'many to one with car' do
      is_expected.to have_many_to_one(:car)
    end

    it 'many to one with tax' do
      is_expected.to have_many_to_one(:tax)
    end

    it 'many to one with user' do
      is_expected.to have_many_to_one(:user)
    end

    it 'one to one with invoice' do
      is_expected.to have_one_to_one(:invoice)
    end
  end
end
