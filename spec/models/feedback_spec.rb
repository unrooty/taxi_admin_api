# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feedback, type: :model do
  let(:attr) { { name: 'Alex', message: 'Some more problems with app.' } }
  let(:feedback) { create(:feedback) }
  context 'supports CRUD:' do
    it 'can be created' do
      expect(feedback).to exist
    end

    it 'can be read' do
      expect(Feedback[feedback.id]).to eq feedback
    end

    it 'can be updated' do
      feedback.update(attr)
      expect([feedback.name, feedback.message]).to eq [
        attr[:name],
        attr[:message]
      ]
    end

    it 'can be deleted' do
      expect(feedback.delete).not_to exist
    end
  end

  context 'supports database validations: ' do
    it 'is invalid without name' do
      expect { create(:feedback, name: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without email' do
      expect { create(:feedback, email: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid with wrong email format' do
      expect { create(:feedback, email: 'abs.bds@.eer.23') }.to raise_error(
        Sequel::DatabaseError
      )
    end

    it 'is invalid without message' do
      expect { create(:feedback, message: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid with too short message' do
      expect { create(:feedback, message: '123') }.to raise_error(
        Sequel::CheckConstraintViolation
      )
    end
  end
end
