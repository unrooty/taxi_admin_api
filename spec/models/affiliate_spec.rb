# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Affiliate, type: :model do
  let(:attr) { { name: 'Taxi-API', address: 'Minsk' } }
  let(:affiliate) { create(:affiliate) }
  context 'supports CRUD:' do
    it 'can be created' do
      expect(affiliate).to exist
    end

    it 'can be read' do
      @affiliate = affiliate
      expect(Affiliate[@affiliate.id]).to eq @affiliate
    end

    it 'can be updated' do
      affiliate.update(attr)
      expect([affiliate.name, affiliate.address]).to eq [attr[:name], attr[:address]]
    end

    it 'can be deleted' do
      expect(affiliate.delete).not_to exist
    end
  end

  context 'supports database validations: ' do
    it 'is invalid without a unique name' do
      affiliate
      expect { create(:affiliate) }.to raise_error(Sequel::DatabaseError)
    end

    it 'is invalid without name' do
      expect { create(:affiliate, name: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without address' do
      expect { create(:affiliate, address: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end
  end

  context 'has association' do
    it 'one to many with users' do
      is_expected.to have_one_to_many(:users)
    end

    it 'one to many with cars' do
      is_expected.to have_one_to_many(:cars)
    end
  end
end
