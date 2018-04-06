# frozen_string_literal: true

require 'airborne'

RSpec.describe 'Cars endpoint' do
  describe 'delete operation' do
    include_context 'admin token'

    let(:car) { create(:car) }
    let(:url) { '/api/v1/cars/' }

    it 'should delete car if user admin' do
      delete url + car.id.to_s, headers: admin_token

      expect_status(204)
    end

    it "should delete car if user manager and car assigned to manager's affiliate" do
      affiliate_id = create(:affiliate).id
      user = create(:user, role: 'Manager', affiliate_id: affiliate_id)
      car = create(:car, affiliate_id: affiliate_id)

      delete url + car.id.to_s, headers: {
        'Access-Token' => JsonWebToken.encode(
          JsonWebToken::USER_IDENTIFIER => user.id
        )
      }

      expect_status(204)
    end

    it "should not delete car if user manager and car not assigned to manager's affiliate" do
      affiliate_id = create(:affiliate).id
      user = create(:user, role: 'Manager', affiliate_id: affiliate_id)
      car = create(:car)

      delete url + car.id.to_s, headers: {
        'Access-Token' => JsonWebToken.encode(
          JsonWebToken::USER_IDENTIFIER => user.id
        )
      }

      expect_status(403)
      expect_json(error: 'Forbidden')
      expect_json_types(error: :string)
    end

    it 'should not delete car if user unauthenticated' do
      delete url + car.id.to_s

      expect_status(401)
      expect_json(error: 'Token absent')
      expect_json_types(error: :string)
    end

    it 'should not delete nonexistent car' do
      delete url + '-1', headers: admin_token

      expect_status(404)
      expect_json(error: 'Not Found')
      expect_json_types(error: :string)
    end

    it 'should not delete car if user not admin/manager' do
      user = create(:user, role: 'Driver')

      delete url + car.id.to_s, headers: {
        'Access-Token' => JsonWebToken.encode(
          JsonWebToken::USER_IDENTIFIER => user.id
        )
      }

      expect_status(403)
      expect_json(error: 'Forbidden')
      expect_json_types(error: :string)

      user = create(:user, role: 'Client')

      delete url + car.id.to_s, headers: {
        'Access-Token' => JsonWebToken.encode(
          JsonWebToken::USER_IDENTIFIER => user.id
        )
      }

      expect_status(403)
      expect_json(error: 'Forbidden')
      expect_json_types(error: :string)

      user = create(:user, role: 'Dispatcher')

      delete url + car.id.to_s, headers: {
        'Access-Token' => JsonWebToken.encode(
          JsonWebToken::USER_IDENTIFIER => user.id
        )
      }

      expect_status(403)
      expect_json(error: 'Forbidden')
      expect_json_types(error: :string)
    end
  end
end
