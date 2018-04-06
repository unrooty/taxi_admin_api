# frozen_string_literal: true

require 'airborne'


RSpec.describe 'Affiliates endpoint ' do
  context 'show operation' do
    include_context 'admin token'
    let(:url) { "/api/v1/affiliates/#{create(:affiliate).id}" }

    it 'should return affiliate to admin' do
      get url, headers: admin_token

      expect_status(200)

      expect_json_types('affiliate', name: :string, address: :string)
    end

    it 'should not return affiliate to unauthorized user' do
      get url

      expect_status(401)

      expect_json_types(error: :string)

      expect_json(error: 'Token absent')
    end

    it 'should not return affiliate to non-admin user' do
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
          JsonWebToken::USER_IDENTIFIER => create(:user, role: 'Manager').id
        )
      }

      expect_status(403)

      expect_json(error: 'Forbidden')

      expect_json_types(error: :string)
    end

    it 'should not return non-existent affiliate' do
      get '/api/v1/affiliates/-1', headers: admin_token

      expect_status(404)

      expect_json(error: 'Not Found')

      expect_json_types(error: :string)
    end
  end
end

