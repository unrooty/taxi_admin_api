# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshToken, type: :model do
  let(:attr) { { token: SecureRandom.base64.to_s, expires_in: 10.minutes.from_now } }
  let(:user) { create(:user) }
  let(:refresh_token) { create(:refresh_token, user_id: user.id) }

  context 'supports CRUD:' do
    it 'can be created' do
      expect(refresh_token).to exist
    end

    it 'can be read' do
      expect(RefreshToken[refresh_token.id]).to eq refresh_token
    end

    it 'can be updated' do
      refresh_token.update(attr)
      expect([refresh_token.token, refresh_token.expires_in]).to eq [
        attr[:token],
        attr[:expires_in]
      ]
    end

    it 'can be deleted' do
      expect(refresh_token.delete).not_to exist
    end
  end

  context 'supports database validations: ' do
    it 'is invalid without token' do
      expect { create(:refresh_token, token: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without expiration time' do
      expect { create(:refresh_token, expires_in: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without user id' do
      expect { create(:refresh_token, user_id: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without device id' do
      expect { create(:refresh_token, device_id: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'has unique token value' do
      create(:refresh_token, token: '12345ABCDE', user_id: user.id)

      expect do
        create(:refresh_token, token: '12345ABCDE',
                               user_id: user.id)
      end.to raise_error(Sequel::UniqueConstraintViolation)
    end

    it 'has unique device id' do
      create(:refresh_token, device_id: 'e87a', user_id: user.id)

      expect do
        create(:refresh_token, device_id: 'e87a', user_id: user.id)
      end.to raise_error(Sequel::UniqueConstraintViolation)
    end

    it "can't be assigned to nonexistent user" do
      expect { create(:refresh_token, user_id: 1) }.to raise_error(
        Sequel::DatabaseError
      )
    end

    it 'can be assigned to existent user' do
      expect(create(:refresh_token, user_id: user.id)).to be_truthy
    end
  end

  context 'has association' do
    it 'many to one with user' do
      is_expected.to have_many_to_one(:user)
    end
  end
end
