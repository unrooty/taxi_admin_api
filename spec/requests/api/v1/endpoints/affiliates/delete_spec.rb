# frozen_string_literal: true

require 'airborne'


RSpec.describe 'Affiliates endpoint' do
  context 'delete operation' do
    let(:admin_token) do
      {
        'Access-Token' => JsonWebToken.encode(
          JsonWebToken::USER_IDENTIFIER => create(:user, role: 'Admin').id
        )
      }
    end
    let(:url) { '/api/v1/affiliates/' }
    it 'should delete affiliate' do
      delete url + create(:affiliate).id.to_s,
             headers: admin_token

      expect_status(204)
    end

    it 'should remove deleted affiliate from cars' do
      affiliate = create(:affiliate)

      5.times do |n|
        create(:car, reg_number: "AA-444#{n}-1",
                     affiliate_id: affiliate.id)
      end

      expect(Car.where(affiliate_id: affiliate.id).count). to eq(5)

      delete url + affiliate.id.to_s,
             headers: admin_token

      expect_status(204)

      expect(Car.where(affiliate_id: affiliate.id).count). to eq(0)
    end

    it 'should not work for unauthenticated user' do
      delete url + create(:affiliate).id.to_s

      expect_status(401)

      expect_json(error: 'Token absent')

      expect_json_types(error: :string)
    end

    it 'should not work for non-admin user' do
      affiliate_id = create(:affiliate).id
      delete url + affiliate_id.to_s,
             headers: {
               'Access-Token' => JsonWebToken.encode(
                 JsonWebToken::USER_IDENTIFIER =>
                     create(:user, role: 'Client').id
               )
             }

      expect_status(403)

      expect_json(error: 'Forbidden')

      expect_json_types(error: :string)

      delete url + affiliate_id.to_s,
             headers: {
               'Access-Token' => JsonWebToken.encode(
                 JsonWebToken::USER_IDENTIFIER =>
                       create(:user, role: 'Manager').id
               )
             }

      expect_status(403)

      expect_json(error: 'Forbidden')

      expect_json_types(error: :string)
    end

    it 'should not delete non-existent affiliate' do
      delete url + '-1', headers: admin_token

      expect_status(404)

      expect_json(error: 'Not Found')

      expect_json_types(error: :string)
    end
  end
end

