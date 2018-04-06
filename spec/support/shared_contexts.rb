# frozen_string_literal: true

shared_context 'admin token' do
  let(:admin_token) do
    {
      'Access-Token' => JsonWebToken.encode(
        JsonWebToken::USER_IDENTIFIER => create(:user, role: 'Admin').id
      )
    }
  end
end
