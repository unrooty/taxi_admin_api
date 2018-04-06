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
  end
end
