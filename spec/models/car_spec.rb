# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Car, type: :model do
  let(:attr) { { reg_number: 'AA-5432-1', color: 'Yellow' } }

  let(:car) { create(:car) }

  context 'supports CRUD:' do
    it 'can be created' do
      expect(car).to exist
    end

    it 'can be read' do
      expect(Car[car.id]).to eq car
    end

    it 'can be updated' do
      car.update(attr)
      expect([car.reg_number, car.color]).to eq [
        attr[:reg_number],
        attr[:color]
      ]
    end

    it 'can be deleted' do
      expect(car.delete).not_to exist
    end
  end

  context 'supports database validations: ' do
    it 'is invalid without brand' do
      expect { create(:car, brand: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without car model' do
      expect { create(:car, car_model: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without registration number' do
      expect { create(:car, reg_number: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid with wrong registration number format' do
      expect { create(:car, reg_number: 'AA-AAA-3235') }.to raise_error(
        Sequel::CheckConstraintViolation
      )
    end

    it 'is invalid without a unique registration number' do
      create(:car, reg_number: 'AA-1234-5')
      expect { create(:car, reg_number: 'AA-1234-5') }.to raise_error(
        Sequel::UniqueConstraintViolation
      )
    end

    it 'is invalid without color' do
      expect { create(:car, color: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without style' do
      expect { create(:car, style: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without car status' do
      expect { create(:car, car_status: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end
  end

  context 'status' do
    it 'can be only "Free" and "Ordered"' do
      expect(create(:car, car_status: 'Free')).to be_truthy
      expect(create(:car, reg_number: 'AA-5432-1',
                          car_status: 'Ordered')).to be_truthy
      expect {
        create(:car, reg_number: 'AA-1357-5',
                     car_status: 'Unfree')
      }.to raise_error(
        Sequel::CheckConstraintViolation
      )
    end

    it 'is "Free" by default' do
      expect(car.car_status).to eq 'Free'
    end
  end

  context 'has methods to check status: ' do
    it 'free?' do
      expect(car.free?).to eq true
    end

    it 'ordered?' do
      car.update(car_status: 'Ordered')
      expect(car.ordered?).to eq true
    end
  end

  context 'has association' do
    it 'many to one with affiliates' do
      is_expected.to have_many_to_one(:affiliate)
    end

    it 'one to one with users' do
      is_expected.to have_one_to_one(:user, key: :id)
    end

    it 'one to many with orders' do
      is_expected.to have_one_to_many(:orders)
    end
  end
end
