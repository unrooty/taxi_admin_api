# frozen_string_literal: true

require 'airborne'

RSpec.describe 'Cars endpoint' do
  context 'create operation' do
    include_context 'admin token'
    let(:car) { attributes_for(:car) }
    let(:url) { '/api/v1/cars' }

    it 'should create car' do
      post url, params: { car: car }, headers: admin_token

      expect_json_types('car', brand: :string,
                               style: :string,
                               color: :string,
                               reg_number: :string,
                               car_model: :string)
      expect_json('car', reg_number: regex(/\A[A-Z]{2}-\d{4}-[1-7]/))
      expect_json_sizes(1)
      expect_status(201)
    end

    it 'should create car and assign it to affiliate if user manager' do
      affiliate_id = create(:affiliate).id
      post url, params: { car: car }, headers: {
        'Access-Token' => JsonWebToken.encode(
          JsonWebToken::USER_IDENTIFIER => create(
            :user, role: 'Manager',
                   affiliate_id: affiliate_id
          ).id
        )
      }

      expect_status(201)
      expect_json_types('car', brand: :string,
                               style: :string,
                               color: :string,
                               reg_number: :string,
                               car_model: :string,
                               affiliate_id: :int)
      expect_json('car', reg_number: regex(/\A[A-Z]{2}-\d{4}-[1-7]/),
                         affiliate_id: affiliate_id)
      expect_json_sizes(1)
    end

    it 'should not create car if user unauthenticated' do
      post url, params: { car: car }

      expect_status(401)
      expect_json(error: 'Token absent')
      expect_json_types(error: :string)
    end

    it 'should check for missed params' do
      post url, params: {
        car: {
          brand: '123',
          color: '123'
        }
      }, headers: admin_token

      expect_status(400)
      expect_json_types(error_code: :int,
                        message: :string,
                        note: :string)
      expect(response.body).to include('is missed')
    end

    it 'should validate params' do
      post url, params: {
        car: {
          brand: '123',
          style: 12,
          color: '',
          reg_number: 'AA-1234-4',
          car_model: '2',
          affiliate_id: 'string'
        }
      }, headers: admin_token

      expect_json_types(error_code: :int,
                        message: :string,
                        note: :string)
      expect_status(422)
    end

    it 'should assign car to driver if user_id present' do
      user_id = create(:user, role: 'Driver').id
      post url, params: {
        car: attributes_for(:car, user_id: user_id)
      }, headers: admin_token

      expect_json_types('car', brand: :string,
                               style: :string,
                               color: :string,
                               reg_number: :string,
                               car_model: :string,
                               user_id: :int)
      expect_json('car', reg_number: regex(/\A[A-Z]{2}-\d{4}-[1-7]/),
                         user_id: user_id)
      expect_json_sizes(1)
      expect_status(201)
    end

    it 'should not assign car to user if user not driver' do
      user_id = create(:user, role: 'Client').id
      post url, params: {
        car: attributes_for(:car, user_id: user_id)
      }, headers: admin_token

      expect_status(422)
      expect_json_types(error: :string)
      expect(response.body).to include('not driver')
    end

    it 'should not assign car to driver if car affiliate id not match driver affiliate id' do
      affiliate_id = create(:affiliate).id
      user_id = create(:user, affiliate_id: affiliate_id, role: 'Driver').id
      post url, params: {
        car: attributes_for(:car, user_id: user_id, affiliate_id: -1)
      }, headers: admin_token

      expect_status(422)
      expect_json(error: 'Car and driver affiliate id must equal')
      expect_json_types(error: :string)
    end

    it 'should not assign car to driver if driver already has car' do
      affiliate_id = create(:affiliate).id
      user_id = create(:user, affiliate_id: affiliate_id,
                              role: 'Driver').id
      create(:car, user_id: user_id)
      post url, params: {
        car: attributes_for(:car, user_id: user_id,
                                  affiliate_id: affiliate_id)
      }, headers: admin_token

      expect_status(422)
      expect_json_types(error: :string)
      expect(response.body).to include('already has car')
    end

    it 'should not create car if user with "user_id" not exists' do
      post url, params: { car: attributes_for(:car, user_id: -1) },
                headers: admin_token

      expect_status(404)
      expect_json_types(error: :string)
      expect(response.body).to include('not exists!')
    end

    it 'should not update car if user not admin or manager' do
      post url, params: { car: attributes_for(:car) },
                headers: {
                  'Access-Token' => JsonWebToken.encode(
                    JsonWebToken::USER_IDENTIFIER => create(:user, role: 'Client').id
                  )
                }

      expect_status(403)
      expect_json(error: 'Forbidden')
      expect_json_types(error: :string)

      post url, params: { car: attributes_for(:car) },
                headers: {
                  'Access-Token' => JsonWebToken.encode(
                    JsonWebToken::USER_IDENTIFIER => create(:user, role: 'Driver').id
                  )
                }

      expect_status(403)
      expect_json(error: 'Forbidden')
      expect_json_types(error: :string)
    end

    it 'should not create car if car number not unique' do
      create(:car, reg_number: 'AA-1111-1')
      post url, params: { car: attributes_for(:car, reg_number: 'AA-1111-1') },
                headers: admin_token

      expect_status(422)
      expect(response.body).to include('has already been taken')
    end
  end
end
