# frozen_string_literal: true

require 'airborne'

RSpec.describe 'Cars endpoint' do
  describe 'index operation' do
    include_context 'admin token'
    let(:url) { '/api/v1/cars/' }
    let(:generate_cars) { 5.times { create(:car) } }

    it 'should return all cars to admin' do
      generate_cars
      get url, headers: admin_token

      expect_status(200)
      expect_json_types('cars.*', brand: :string,
                                  style: :string,
                                  color: :string,
                                  reg_number: :string,
                                  car_model: :string)
      expect_json('cars.*', reg_number: regex(/\A[A-Z]{2}-\d{4}-[1-7]/))
    end

    it 'should not return cars if user not admin' do
      generate_cars
      get url, headers: {
        'Access-Token' => JsonWebToken.encode(
          JsonWebToken::USER_IDENTIFIER => create(:user, role: 'Client').id
        )
      }

      expect_status(403)
      expect_json(error: 'Forbidden')
      expect_json_types(error: :string)

      get url, headers: {
        'Access-Token' => JsonWebToken.encode(
          JsonWebToken::USER_IDENTIFIER => create(:user, role: 'Driver').id
        )
      }

      expect_status(403)
      expect_json(error: 'Forbidden')
      expect_json_types(error: :string)
    end

    it 'should not return cars if user unauthenticated' do
      get url

      expect_status(401)
      expect_json(error: 'Token absent')
      expect_json_types(error: :string)
    end

    it 'should return only special cars for manager' do
      affiliate_id = create(:affiliate).id
      5.times { create(:car, affiliate_id: affiliate_id) }
      user = create(:user, role: 'Manager',
                           affiliate_id: affiliate_id)
      get url, headers:
          {
            'Access-Token' => JsonWebToken.encode(
              JsonWebToken::USER_IDENTIFIER => user.id
            )
          }

      expect_json_types('cars.*', affiliate_id: :int,
                                  brand: :string,
                                  style: :string,
                                  color: :string,
                                  reg_number: :string,
                                  car_model: :string)
      expect_json('cars.*', reg_number: regex(/\A[A-Z]{2}-\d{4}-[1-7]/),
                            affiliate_id: affiliate_id)
    end
  end
end

