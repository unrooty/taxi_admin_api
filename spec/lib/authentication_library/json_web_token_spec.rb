
# frozen_string_literal: true

require File.expand_path('../../rails_helper', __dir__)

RSpec.describe JsonWebToken do
  let(:jwt) { JsonWebToken.encode(user_id: 1) }

  it 'can be encoded with default time' do
    expect(jwt).to be_truthy
  end

  it 'can be encoded with special time' do
    expect(JsonWebToken.encode({ user_id: 1 },
                               12.minutes.from_now)).to be_truthy
  end

  it 'can be decoded' do
    expect(JsonWebToken.decode(jwt)).to be_truthy
  end

  it "can't be decoded if expired" do
    token = JsonWebToken.encode({ user_id: 1 }, Time.now - 1.minute)
    expect(JsonWebToken.decode(token)).to be_falsey
  end
end
