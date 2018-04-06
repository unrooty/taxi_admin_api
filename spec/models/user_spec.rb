# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:attr) { { last_name: 'Odmen', phone: '987654321' } }
  let(:user) { create(:user) }

  context 'supports CRUD:' do
    it 'can be created' do
      expect(user).to exist
    end

    it 'can be read' do
      expect(User[user.id]).to eq user
    end

    it 'can be updated' do
      user.update(attr)
      expect([user.last_name, user.phone]).to eq [
        attr[:last_name],
        attr[:phone]
      ]
    end

    it 'can be deleted' do
      expect(user.delete).not_to exist
    end
  end

  context 'supports database validations:' do
    it 'is invalid without email' do
      expect { create(:user, email: nil) }.to raise_error(
        Sequel::ValidationFailed
      )
    end

    it 'is invalid without a unique email' do
      create(:user, email: 'useremail@ex.com')
      expect { create(:user,  email: 'useremail@ex.com') }.to raise_error(
        Sequel::ValidationFailed
      )
    end

    it 'is invalid with wrong email format' do
      expect { create(:user, email: 'email') }.to raise_error(
        Sequel::ValidationFailed
      )
    end

    it 'is invalid without password' do
      expect do
        create(:user, password: nil,
                      password_confirmation: nil)
      end .to raise_error(
        Sequel::ValidationFailed
      )
    end

    it 'is invalid without password confirmation' do
      expect do
        create(:user, password: '12345678',
                      password_confirmation: nil)
      end .to raise_error(
        Sequel::ValidationFailed
      )
    end

    it 'is invalid with too short password (less than 8 characters)' do
      expect do
        create(:user, password: '12345',
                      password_confirmation: '12345')
      end .to raise_error(
        Sequel::ValidationFailed
      )
    end

    it 'is invalid without first name' do
      expect { create(:user, first_name: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without last name' do
      expect { create(:user, last_name: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid without phone' do
      expect { create(:user, phone: nil) }.to raise_error(
        Sequel::NotNullConstraintViolation
      )
    end

    it 'is invalid with wrong phone length (must be 9)' do
      # 8
      expect do
        create(:user, phone: '12345678')
      end.to raise_error(Sequel::DatabaseError)
      # 10
      expect do
        create(:user, phone: '1234567890')
      end.to raise_error(Sequel::DatabaseError)
    end

    it 'is invalid without role' do
      expect { create(:user, role: nil) }.to raise_error(
        Sequel::DatabaseError
      )
    end

    it 'is invalid without language' do
      expect { create(:user, language: nil) }.to raise_error(
        Sequel::DatabaseError
      )
    end

    it 'is invalid without "active"' do
      expect { create(:user, active: nil) }.to raise_error(
        Sequel::DatabaseError
      )
    end
  end

  context 'role' do
    it 'can be only "Admin", "Client", "Driver", "Dispatcher",
      "Accountant" or "Manager"' do

      expect(create(:user, email: 'admin1@gmail.com',
                           role: 'Admin')).to be_truthy

      expect(create(:user, email: 'client1@gmail.com',
                           role: 'Client')).to be_truthy

      expect(create(:user, email: 'driver1@gmail.com',
                           role: 'Driver')).to be_truthy

      expect(create(:user, email: 'dispatcher1@gmail.com',
                           role: 'Dispatcher')).to be_truthy

      expect(create(:user, email: 'accountant1@gmail.com',
                           role: 'Accountant')).to be_truthy

      expect(create(:user, email: 'manager1@gmail.com',
                           role: 'Manager')).to be_truthy

      expect { create(:user, role: 'SUPERMEGAADMIN') }.to raise_error(
        Sequel::DatabaseError
      )
    end

    it '"Client" by default' do
      expect(user.role).to eq 'Client'
    end
  end

  context 'profile' do
    it 'active by default' do
      expect(user.active).to be_truthy
    end

    it 'can be confirmed' do
      expect(create(:user, confirmed_at: Time.now)).to be_truthy
    end

    it 'can be deactivated' do
      user.update(active: false)
      expect(user.active).to be_falsey
    end
  end

  context 'has methods to check role: ' do
    it 'client?' do
      expect(user.client?).to eq true
    end

    it 'admin?' do
      user.update(role: 'Admin')
      expect(user.admin?).to eq true
    end

    it 'manager?' do
      user.update(role: 'Manager')
      expect(user.manager?).to eq true
    end

    it 'accountant?' do
      user.update(role: 'Accountant')
      expect(user.accountant?).to eq true
    end

    it 'driver?' do
      user.update(role: 'Driver')
      expect(user.driver?).to eq true
    end

    it 'dispatcher?' do
      user.update(role: 'Dispatcher')
      expect(user.dispatcher?).to eq true
    end
  end

  context 'has association' do
    it 'many to one affiliate' do
      is_expected.to have_many_to_one(:affiliate)
    end

    it 'one to many with orders' do
      is_expected.to have_one_to_many(:orders)
    end

    it 'one to one with car' do
      is_expected.to have_one_to_one(:car)
    end

    it 'one to many with refresh tokens' do
      is_expected.to have_one_to_many(:refresh_tokens, key: :id)
    end
  end
end
