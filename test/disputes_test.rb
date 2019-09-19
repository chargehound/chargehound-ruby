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

dispute_create = {
  id: 'dp_123'
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
      name:        'Saxophone',
      description: 'Alto saxophone, with carrying case',
      image:       'http://s3.amazonaws.com/chargehound/saxophone.png',
      sku:         '17283001272',
      quantity:    1,
      amount:      20_000,
      url:         'http://www.example.com'
    }, {
      name:        'Milk',
      description: 'Semi-skimmed Organic',
      image:       'http://s3.amazonaws.com/chargehound/milk.png',
      sku:         '26377382910',
      quantity:    '64oz',
      amount:      400,
      url:         'http://www.example.com'
    }
  ]
}

dispute_with_product_info_response = {
  id: 'dp_123',
  object: 'dispute',
  fields: {
    customer_name: 'Susie'
  },
  products: [
    {
      name:        'Saxophone',
      description: 'Alto saxophone, with carrying case',
      image:       'http://s3.amazonaws.com/chargehound/saxophone.png',
      sku:         '17283001272',
      quantity:    1,
      amount:      20_000,
      url:         'http://www.example.com'
    }, {
      name:        'Milk',
      description: 'Semi-skimmed Organic',
      image:       'http://s3.amazonaws.com/chargehound/milk.png',
      sku:         '26377382910',
      quantity:    '64oz',
      amount:      400,
      url:         'http://www.example.com'
    }
  ]
}

dispute_with_correspondence_info_update = {
  fields: {
    customer_name: 'Susie'
  },
  correspondence: [
    {
      to: 'customer@example.com',
      from: 'noreply@example.com',
      subject: 'Your Order',
      body: 'Your order was received.',
      caption: 'Order confirmation email.'
    }, {
      to: 'customer@example.com',
      from: 'noreply@example.com',
      subject: 'Your Order',
      body: 'Your order was delivered.',
      caption: 'Delivery confirmation email.'
    }
  ]
}

dispute_with_correspondence_info_response = {
  id: 'dp_123',
  object: 'dispute',
  fields: {
    customer_name: 'Susie'
  },
  correspondence: [
    {
      to: 'customer@example.com',
      from: 'noreply@example.com',
      subject: 'Your Order',
      body: 'Your order was received.',
      caption: 'Order confirmation email.'
    }, {
      to: 'customer@example.com',
      from: 'noreply@example.com',
      subject: 'Your Order',
      body: 'Your order was delivered.',
      caption: 'Delivery confirmation email.'
    }
  ]
}

dispute_with_past_payments_update = {
  fields: {
    customer_name: 'Susie'
  },
  past_payments: [
    {
      id: 'ch_1',
      amount: 20_000,
      currency: 'usd',
      charged_at: '2019-09-10 11:09:41PM UTC'
    }, {
      id: 'ch_2',
      amount: 50_000,
      currency: 'usd',
      charged_at: '2019-09-03 11:09:41PM UTC'
    }
  ]
}

dispute_with_past_payments_response = {
  id: 'dp_123',
  object: 'dispute',
  fields: {
    customer_name: 'Susie'
  },
  past_payments: [
    {
      id: 'ch_1',
      amount: 20_000,
      currency: 'usd',
      charged_at: '2019-09-10 11:09:41PM UTC'
    }, {
      id: 'ch_2',
      amount: 50_000,
      currency: 'usd',
      charged_at: '2019-09-03 11:09:41PM UTC'
    }
  ]
}

dispute_response = {
  id: 'dp_123',
  object: 'dispute'
}

dispute_list_response = {
  object: 'list',
  data: [{
    id: 'dp_123',
    object: 'dispute'
  }]
}

response_response = {
  dispute_id: 'dp_123',
  object: 'response'
}

describe Chargehound::Disputes do
  before do
    Chargehound.api_key = 'API_KEY'
  end

  after do
    WebMock.reset!
  end

  it 'can expose the response status code' do
    stub = stub_request(:get, 'https://api.chargehound.com/v1/disputes')
           .with(headers: get_headers)
           .to_return(body: dispute_list_response.to_json)

    list = Chargehound::Disputes.list
    assert_requested stub
    assert_equal('200', list.response.status)
  end

  it 'uses typed response objects' do
    stub = stub_request(:get, 'https://api.chargehound.com/v1/disputes')
           .with(headers: get_headers)
           .to_return(body: dispute_list_response.to_json)

    list = Chargehound::Disputes.list
    assert_requested stub

    assert_instance_of(Chargehound::List, list)
    assert_instance_of(Chargehound::Dispute, list.data[0])

    assert_equal('list', list.object)
    assert_equal('dp_123', list.data[0].id)
  end

  it 'typed response objects can be JSON stringified' do
    stub = stub_request(:get, 'https://api.chargehound.com/v1/disputes')
           .with(headers: get_headers)
           .to_return(body: dispute_list_response.to_json)

    list = Chargehound::Disputes.list
    assert_requested stub

    list_hash = list.as_json
    list_json = list.to_json

    response = {
      object: 'list',
      data: [{
        id: 'dp_123',
        object: 'dispute',
        products: [],
        correspondence: [],
        past_payments: []
      }],
      response: {
        status: '200'
      }
    }

    assert_equal(response, list_hash)
    assert_equal(response.to_json, list_json)
  end

  it 'can create a dispute' do
    stub = stub_request(:post, 'https://api.chargehound.com/v1/disputes')
           .with(headers: post_headers)
           .to_return(body: dispute_response.to_json)

    Chargehound::Disputes.create(dispute_create)
    assert_requested stub
  end

  it 'can list disputes' do
    stub = stub_request(:get, 'https://api.chargehound.com/v1/disputes')
           .with(headers: get_headers)
           .to_return(body: dispute_list_response.to_json)

    Chargehound::Disputes.list
    assert_requested stub
  end

  it 'can list disputes filtered by state' do
    stub = stub_request(:get, 'https://api.chargehound.com/v1/disputes?state=needs_response')
           .with(headers: get_headers)
           .to_return(body: dispute_list_response.to_json)

    Chargehound::Disputes.list(state: %w[needs_response])
    assert_requested stub
  end

  it 'can list disputes filtered by multiple states' do
    stub = stub_request(:get, 'https://api.chargehound.com/v1/disputes?state=needs_response&state=warning_needs_response')
           .with(headers: get_headers)
           .to_return(body: dispute_list_response.to_json)

    Chargehound::Disputes.list(state: %w[needs_response warning_needs_response])
    assert_requested stub
  end

  it 'can retrieve a dispute' do
    stub = stub_request(:get, 'https://api.chargehound.com/v1/disputes/dp_123')
           .with(headers: get_headers)
           .to_return(body: dispute_response.to_json)

    Chargehound::Disputes.retrieve('dp_123')
    assert_requested stub
  end

  it 'can retrieve a dispute response' do
    stub = stub_request(:get, 'https://api.chargehound.com/v1/disputes/dp_123/response')
           .with(headers: get_headers)
           .to_return(body: response_response.to_json)

    response = Chargehound::Disputes.response('dp_123')
    assert_instance_of(Chargehound::Response, response)
    assert_equal('dp_123', response.dispute_id)
    assert_requested stub
  end

  it 'can submit a dispute' do
    stub = stub_request(:post, 'https://api.chargehound.com/v1/disputes/dp_123/submit')
           .with(headers: post_headers,
                 body: dispute_update.to_json)
           .to_return(body: dispute_response.to_json,
                      status: 201)

    Chargehound::Disputes.submit('dp_123', dispute_update)
    assert_requested stub
  end

  it 'can accept a dispute' do
    # Does not set content type b/c there is no body
    headers = get_headers
    stub = stub_request(:post, 'https://api.chargehound.com/v1/disputes/dp_123/accept')
           .with(headers: headers)
           .to_return(body: dispute_response.to_json,
                      status: 200)

    Chargehound::Disputes.accept('dp_123')
    assert_requested stub
  end

  it 'can submit a dispute with product data' do
    stub = stub_request(:post, 'https://api.chargehound.com/v1/disputes/dp_123/submit')
           .with(headers: post_headers,
                 body: dispute_with_product_info_update.to_json)
           .to_return(body: dispute_with_product_info_response.to_json,
                      status: 201)

    Chargehound::Disputes.submit('dp_123', dispute_with_product_info_update)
    assert_requested stub
  end

  it 'has a model for product data' do
    stub = stub_request(:post, 'https://api.chargehound.com/v1/disputes/dp_123/submit')
           .with(headers: post_headers,
                 body: dispute_with_product_info_update.to_json)
           .to_return(body: dispute_with_product_info_response.to_json,
                      status: 201)

    dispute = Chargehound::Disputes.submit('dp_123',
                                           dispute_with_product_info_update)

    assert_instance_of(Chargehound::Product, dispute.products[0])
    assert_requested stub
  end

  it 'can submit a dispute with correspondence data' do
    stub = stub_request(:post, 'https://api.chargehound.com/v1/disputes/dp_123/submit')
           .with(headers: post_headers,
                 body: dispute_with_correspondence_info_update.to_json)
           .to_return(body: dispute_with_correspondence_info_response.to_json,
                      status: 201)

    Chargehound::Disputes.submit('dp_123',
                                 dispute_with_correspondence_info_update)
    assert_requested stub
  end

  it 'has a model for correspondence data' do
    stub = stub_request(:post, 'https://api.chargehound.com/v1/disputes/dp_123/submit')
           .with(headers: post_headers,
                 body: dispute_with_correspondence_info_update.to_json)
           .to_return(body: dispute_with_correspondence_info_response.to_json,
                      status: 201)

    dispute = Chargehound::Disputes.submit(
      'dp_123', dispute_with_correspondence_info_update
    )

    assert_instance_of(Chargehound::CorrespondenceItem,
                       dispute.correspondence[0])
    assert_requested stub
  end

  it 'can submit a dispute with past payments data' do
    stub = stub_request(:post, 'https://api.chargehound.com/v1/disputes/dp_123/submit')
           .with(headers: post_headers,
                 body: dispute_with_past_payments_update.to_json)
           .to_return(body: dispute_with_past_payments_response.to_json,
                      status: 201)

    Chargehound::Disputes.submit('dp_123', dispute_with_past_payments_update)
    assert_requested stub
  end

  it 'has a model for past payments data' do
    stub = stub_request(:post, 'https://api.chargehound.com/v1/disputes/dp_123/submit')
           .with(headers: post_headers,
                 body: dispute_with_past_payments_update.to_json)
           .to_return(body: dispute_with_past_payments_response.to_json,
                      status: 201)

    dispute = Chargehound::Disputes.submit('dp_123',
                                           dispute_with_past_payments_update)

    assert_instance_of(Chargehound::PastPayment, dispute.past_payments[0])
    assert_requested stub
  end

  it 'can update a dispute' do
    stub = stub_request(:put, 'https://api.chargehound.com/v1/disputes/dp_123')
           .with(headers: post_headers, body: dispute_update.to_json)
           .to_return(body: dispute_response.to_json)

    Chargehound::Disputes.update('dp_123', dispute_update)
    assert_requested stub
  end

  it 'can update a dispute with product data' do
    stub = stub_request(:put, 'https://api.chargehound.com/v1/disputes/dp_123')
           .with(headers: post_headers,
                 body: dispute_with_product_info_update.to_json)
           .to_return(body: dispute_response.to_json)

    Chargehound::Disputes.update('dp_123', dispute_with_product_info_update)
    assert_requested stub
  end

  it 'can update a dispute with correspondence data' do
    stub = stub_request(:put, 'https://api.chargehound.com/v1/disputes/dp_123')
           .with(headers: post_headers,
                 body: dispute_with_correspondence_info_update.to_json)
           .to_return(body: dispute_response.to_json)

    Chargehound::Disputes.update('dp_123',
                                 dispute_with_correspondence_info_update)
    assert_requested stub
  end
end
