require 'test_helper'

get_headers = {
  'Accept' => 'application/json',
  'Authorization' => 'Basic QVBJX0tFWTo=',
  'User-Agent' => "Chargehound/v1 RubyBindings/#{Chargehound::VERSION}"
}

post_headers = {
  'Accept' => 'application/json',
  'Authorization' => 'Basic QVBJX0tFWTo=',
  'Content-Type' => 'application/json',
  'User-Agent' => "Chargehound/v1 RubyBindings/#{Chargehound::VERSION}"
}

dispute_update = {
  fields: {
    customer_name: 'Susie'
  }
}

dispute_with_product_info_update = {
  fields: {
    customer_name: 'Susie'
  },
  products: [
    {
      name:        'Product Name 1',
      description: 'Product Description (optional)',
      image:       'Product Image URL (optional)',
      sku:         'Stock Keeping Unit (optional)',
      quantity:    1,
      amount:      1000,
      url:         'Product URL (optional)'
    }, {
      name:        'Product Name 2',
      description: 'Product Description (optional)',
      image:       'Product Image URL (optional)',
      sku:         'Stock Keeping Unit (optional)',
      quantity:    '10oz',
      amount:      2000,
      url:         'Product URL (optional)'
    }
  ]
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
           .with(headers: post_headers,
                 body: dispute_update.to_json)
           .to_return(body: dispute_response,
                      status: 201)

    Chargehound::Disputes.submit('dp_123', dispute_update)
    assert_requested stub
  end

  it 'can submit a dispute with product data' do
    stub = stub_request(:post, 'https://api.chargehound.com/v1/disputes/dp_123/submit')
           .with(headers: post_headers,
                 body: dispute_with_product_info_update.to_json)
           .to_return(body: dispute_response,
                      status: 201)

    Chargehound::Disputes.submit('dp_123', dispute_with_product_info_update)
    assert_requested stub
  end

  it 'can update a dispute' do
    stub = stub_request(:put, 'https://api.chargehound.com/v1/disputes/dp_123')
           .with(headers: post_headers, body: dispute_update.to_json)
           .to_return(body: dispute_response)

    Chargehound::Disputes.update('dp_123', dispute_update)
    assert_requested stub
  end

  it 'can update a dispute with product data' do
    stub = stub_request(:put, 'https://api.chargehound.com/v1/disputes/dp_123')
           .with(headers: post_headers,
                 body: dispute_with_product_info_update.to_json)
           .to_return(body: dispute_response)

    Chargehound::Disputes.update('dp_123', dispute_with_product_info_update)
    assert_requested stub
  end
end
