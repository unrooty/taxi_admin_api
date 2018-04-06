# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tax, type: :model do
  let(:attr) { { basic_cost: 2.5, name: 'Pre-basic' } }
  let(:tax) { create(:tax) }

  context 'supports CRUD:' do
    it 'can be created' do
      expect(tax).to exist
    end

    it 'can be read' do
      expect(Tax[tax.id]).to eq tax
    end

    it 'can be updated' do
      tax.update(attr)
      expect([tax.basic_cost, tax.name]).to eq [
        attr[:basic_cost],
        attr[:name]
      ]
    end

    it 'can be set as deleted' do
      expect(tax.update(deleted: true)).to be_truthy
    end

    it 'can be deleted' do
      expect(tax.delete).not_to exist
    end
  end

  context 'supports database validations: ' do
    it 'is invalid without name' do
      expect { create(:tax, name: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without basic cost' do
      expect { create(:tax, basic_cost: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without cost per km' do
      expect { create(:tax, cost_per_km: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid with negative basic cost' do
      expect { create(:tax, basic_cost: -2) }.to raise_error(
        Sequel::CheckConstraintViolation
      )
    end

    it 'is invalid with negative cost per km' do
      expect { create(:tax, cost_per_km: -1) }.to raise_error(
        Sequel::CheckConstraintViolation
      )
    end

    it "can't be default if default tax already exists" do
      create(:tax, by_default: true)
      expect { create(:tax, by_default: true) }.to raise_error(
        Sequel::DatabaseError
      )
    end

    it "can't be deleted if has associated orders" do
      @tax = tax
      create(:order, tax_id: @tax.id)
      expect { @tax.delete }.to raise_error(Sequel::DatabaseError)
    end

    it "can't be deleted if default" do
      @tax = create(:tax, by_default: true)
      expect { @tax.delete }.to raise_error(Sequel::DatabaseError)
    end
  end

  context 'has association' do
    it 'one to many orders' do
      is_expected.to have_one_to_many(:orders)
    end
  end
end
