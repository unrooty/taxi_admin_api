# frozen_string_literal: true

require 'airborne'

RSpec.describe 'Affiliates endpoint' do
  context 'create operation' do
    let(:user) { create(:user, role: 'Admin') }
    let(:affiliate) { attributes_for(:affiliate) }

    it 'should be allowed to admin' do
      post '/api/v1/affiliates',
           params: {
             affiliate: affiliate
           },
           headers: {
             'Access-Token' =>
                 JsonWebToken.encode(
                   JsonWebToken::USER_IDENTIFIER => user.id
                 )
           }

      expect_status(201)

      expect_json_types('affiliate', name: :string, address: :string)
    end

    it 'should validate params' do
      post '/api/v1/affiliates',
           params: {
             affiliate: {
               name: '',
               address: ''
             }
           },
           headers: {
             'Access-Token' =>
                 JsonWebToken.encode(
                   JsonWebToken::USER_IDENTIFIER => user.id
                 )
           }

      expect_status(422)

      expect_json_types(error_code: :int,
                        message: :string,
                        note: :string)

      expect(response.body).to include('is empty')

      expect(response.body).to include('422')
    end

    it 'should check for name uniqueness' do
      create(:affiliate)
      post '/api/v1/affiliates',
           params: {
             affiliate: affiliate
           },
           headers: {
             'Access-Token' =>
                 JsonWebToken.encode(
                   JsonWebToken::USER_IDENTIFIER => user.id
                 )
           }

      expect_status(422)

      expect_json_types('error', name: :array_of_strings)

      expect(response.body).to include('already been taken')
    end

    it 'should check for missed params' do
      post '/api/v1/affiliates',
           params: {
             affiliate: {
               address: 'Minsk'
             }
           },
           headers: {
             'Access-Token' =>
                   JsonWebToken.encode(
                     JsonWebToken::USER_IDENTIFIER => user.id
                   )
           }

      expect_status(400)

      expect_json_types(error_code: :int,
                        message: :string,
                        note: :string)

      expect(response.body).to include('is missed')

      expect(response.body).to include('400')
    end

    it 'forbidden for unauthenticated user' do
      post '/api/v1/affiliates',
           params: {
             affiliate: affiliate
           }

      expect_status(401)

      expect_json_types(error: :string)

      expect_json(error: 'Token absent')
    end

    it 'forbidden if user not admin' do
      user = create(:user, role: 'Driver')
      post '/api/v1/affiliates',
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
  end
end

