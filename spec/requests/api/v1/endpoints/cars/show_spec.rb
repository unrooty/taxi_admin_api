# frozen_string_literal: true

require 'airborne'

RSpec.describe 'Cars endpoint' do
  context 'show operation' do
    include_context 'admin token'
    let(:url) { "/api/v1/cars/#{create(:car).id}" }

    it 'should return car to admin' do
      get url, headers: admin_token

      expect_status(200)
      expect_json_types('car', brand: :string,
                               style: :string,
                               color: :string,
                               reg_number: :string,
                               car_model: :string)
      expect_json('car', reg_number: regex(/\A[A-Z]{2}-\d{4}-[1-7]/))
      expect_json_sizes(1)
    end

    it "should return car to manager if it's assigned to manager's affiliate" do
      affiliate_id = create(:affiliate).id
      get "/api/v1/cars/#{create(:car, affiliate_id: affiliate_id).id}",
          headers: {
            'Access-Token' => JsonWebToken.encode(
              JsonWebToken::USER_IDENTIFIER => create(:user, role: 'Manager',
                                                             affiliate_id: affiliate_id).id
            )
          }

      expect_status(200)
      expect_json_types('car', brand: :string,
                               style: :string,
                               color: :string,
                               reg_number: :string,
                               car_model: :string)
      expect_json('car', reg_number: regex(/\A[A-Z]{2}-\d{4}-[1-7]/))
      expect_json_sizes(1)
    end

    it "should not return car to manager if it's not assigned to manager's affiliate" do
      get url, headers: {
        'Access-Token' => JsonWebToken.encode(
          JsonWebToken::USER_IDENTIFIER => create(
            :user, role: 'Manager',
                   affiliate_id: create(:affiliate).id
          ).id
        )
      }
      expect_json(error: 'Forbidden')
      expect_status(403)
      expect_json_types(error: :string)
    end

    it 'should not return nonexistent car' do
      get '/api/v1/cars/-1', headers: admin_token

      expect_status(404)
      expect_json(error: 'Not Found')
      expect_json_types(error: :string)
    end

    it 'should not return car to unauthenticated user' do
      get url

      expect_status(401)
      expect_json(error: 'Token absent')
      expect_json_types(error: :string)
    end
  end
end
