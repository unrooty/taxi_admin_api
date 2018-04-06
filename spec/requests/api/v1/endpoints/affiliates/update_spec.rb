# frozen_string_literal: true

require 'airborne'

RSpec.describe 'affiliates endpoint' do
  context 'update operation' do
    let(:user) { create(:user, role: 'Admin') }
    let(:affiliate) { attributes_for(:affiliate) }
    let(:admin_token) do
      {
        'Access-Token' => JsonWebToken.encode(
          JsonWebToken::USER_IDENTIFIER => user.id
        )
      }
    end
    let(:url) { "/api/v1/affiliates/#{create(:affiliate).id}" }

    it 'should be allowed to admin' do
      patch url,
            params: {
              affiliate: {
                name: 'Taxi-Shmaxi',
                address: affiliate[:address]
              }
            },
            headers: admin_token

      expect_status(200)

      expect_json_types('affiliate', name: :string, address: :string)
    end

    it 'should validate params' do
      patch url,
            params: {
              affiliate: {
                name: '',
                address: ''
              }
            },
            headers: admin_token

      expect_status(422)

      expect_json_types(error_code: :int,
                        message: :string,
                        note: :string)

      expect(response.body).to include('is empty')

      expect(response.body).to include('422')
    end

    it 'should check for name uniqueness' do
      create(:affiliate)
      aff = create(:affiliate, name: 'Taxi')

      patch "/api/v1/affiliates/#{aff.id}",
            params: {
              affiliate: affiliate
            },
            headers: admin_token

      expect_status(422)

      expect_json_types('error', name: :array_of_strings)

      expect(response.body).to include('already been taken')
    end

    it 'should check for missed params' do
      patch url,
            params: {
              affiliate: {
                address: 'Minsk'
              }
            },
            headers: admin_token

      expect_status(400)

      expect_json_types(error_code: :int,
                        message: :string,
                        note: :string)

      expect(response.body).to include('is missed')

      expect(response.body).to include('400')
    end

    it 'forbidden for unauthenticated user' do
      patch url,
            params: {
              affiliate: affiliate
            }

      expect_status(401)

      expect_json_types(error: :string)

      expect_json(error: 'Token absent')
    end

    it 'forbidden if user not admin' do
      user = create(:user, role: 'Driver')
      patch url,
            params: {
              affiliate: affiliate
            },
            headers: {
              'Access-Token' =>
                  JsonWebToken.encode(
                    JsonWebToken::USER_IDENTIFIER => user.id
                  )
            }
      expect_status(403)

      expect_json_types(error: :string)

      expect_json(error: 'Forbidden')
    end

    it 'should not update non-existent affiliate' do
      patch '/api/v1/affiliates/-1',
            params: {
              affiliate: affiliate
            },
            headers: admin_token

      expect_status(404)

      expect_json(error: 'Not Found')

      expect_json_types(error: :string)
    end
  end
end

