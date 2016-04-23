require 'test_helper'

original_host = Chargehound.host

auth_header = {
  'Authorization' => 'Basic QVBJX0tFWTo='
}

describe Chargehound do
  after do
    Chargehound.api_key = ''
    Chargehound.host = original_host
    WebMock.reset!
  end

  it 'can set the API key on the module' do
    Chargehound.api_key = 'API_KEY'
    stub = stub_request(:get, 'https://api.chargehound.com/v1/disputes')
           .with(headers: auth_header)
           .to_return(body: {}.to_json)

    Chargehound::Disputes.list
    assert_requested stub
  end

  it 'can set the base host on the module' do
    Chargehound.host = 'test'
    stub = stub_request(:get, 'https://test/v1/disputes')
           .to_return(body: {}.to_json)

    Chargehound::Disputes.list
    assert_requested stub
  end
end
