# frozen_string_literal: true

require File.expand_path('../../rails_helper', __dir__)
include AuthenticationLibrary::AuthHelpers

RSpec.describe AuthenticationLibrary::AuthHelpers do
  def error!(_message, status)
    status
  end
  let(:request) { double('request', headers: { 'Accept' => 'application/json' }) }
  let(:user) { create(:user) }
  let(:request_with_access_token) do
    request.headers['Access-Token'] = JsonWebToken.encode(user: user.id)
  end

  it 'returns 401 if token absent' do
    request
    expect(authenticate_user!).to eq 401
  end

  it 'returns 401 if  token invalid' do
    request.headers['Access-Token'] = JsonWebToken.encode({ user: 1 },
                                                          Time.now - 10.seconds)
    expect(authenticate_user!).to eq 401
  end

  it "returns 403 if user's account not confirmed" do
    request_with_access_token
    expect(authenticate_user!).to eq 403
  end

end
