require 'test_helper'

get_headers = {
  'Accept' => 'application/json',
  'Authorization' => 'Basic QVBJX0tFWTo=',
  'User-Agent' => 'Chargehound/v1 RubyBindings/1.0.0'
}

post_headers = {
  'Accept' => 'application/json',
  'Authorization' => 'Basic QVBJX0tFWTo=',
  'Content-Type' => 'application/json',
  'User-Agent' => 'Chargehound/v1 RubyBindings/1.0.0'
}

dispute_update = {
  fields: {
    'customer_name' => 'Susie'
  }
}

dispute_response = {
  'id' => 'dp_123'
}.to_json

describe Chargehound::Disputes do
  before do
    Chargehound.api_key = 'API_KEY'
  end

  after do
    WebMock.reset!
  end

  it 'can list disputes' do
    stub = stub_request(:get, 'https://api.chargehound.com/v1/disputes')
           .with(headers: get_headers)
           .to_return(body: dispute_response)

    Chargehound::Disputes.list
    assert_requested stub
  end

  it 'can retrieve a dispute' do
    stub = stub_request(:get, 'https://api.chargehound.com/v1/disputes/dp_123')
           .with(headers: get_headers)
           .to_return(body: dispute_response)

    Chargehound::Disputes.retrieve('dp_123')
    assert_requested stub
  end

  it 'can submit a dispute' do
    stub = stub_request(:post, 'https://api.chargehound.com/v1/disputes/dp_123/submit')
           .with(headers: post_headers, body: dispute_update.to_json)
           .to_return(body: dispute_response)

    Chargehound::Disputes.submit('dp_123', dispute_update)
    assert_requested stub
  end

  it 'can update a dispute' do
    stub = stub_request(:put, 'https://api.chargehound.com/v1/disputes/dp_123')
           .with(headers: post_headers, body: dispute_update.to_json)
           .to_return(body: dispute_response)

    Chargehound::Disputes.update('dp_123', dispute_update)
    assert_requested stub
  end
end
