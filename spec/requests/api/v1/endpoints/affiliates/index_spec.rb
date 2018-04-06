# frozen_string_literal: true

require 'airborne'


RSpec.describe 'Affiliates endpoint' do
  context 'index operation' do
    it 'should return all affiliates to admin' do
      10.times { |n| create(:affiliate, name: "Taxi-Aff#{n}") }
      user = create(:user, role: 'Admin')
      get '/api/v1/affiliates',
          headers: { 'Access-Token' =>
                         JsonWebToken.encode(
                           JsonWebToken::USER_IDENTIFIER => user.id
                         ) }

      expect_status(200)

      expect_json_types('affiliates.*', name: :string, address: :string)
    end

    it 'should not return affiliates if user not admin' do
      client = create(:user, email: 'client@email.com', role: 'Client')

      manager = create(:user, email: 'manager@email.com', role: 'Manager')

      get '/api/v1/affiliates',
          headers: { 'Access-Token' =>
                         JsonWebToken.encode(
                           JsonWebToken::USER_IDENTIFIER => client.id
                         ) }

      expect_status(403)

      expect_json(error: 'Forbidden')

      expect_json_types(error: :string)

      get '/api/v1/affiliates',
          headers: { 'Access-Token' =>
                         JsonWebToken.encode(
                           JsonWebToken::USER_IDENTIFIER => manager.id
                         ) }

      expect_status(403)

      expect_json(error: 'Forbidden')

      expect_json_types(error: :string)
    end

    it 'should not return anything if user unauthorized' do
      get '/api/v1/affiliates'

      expect_status(401)

      expect_json_types(error: :string)

      expect_json(error: 'Token absent')
    end
  end
end

