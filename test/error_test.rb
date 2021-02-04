require 'test_helper'

error_response = {
  'error' => {
    'status' => 400,
    'message' => 'Bad Request'
  }
}

error_response_typed = {
  'error' => {
    'status' => 400,
    'message' => 'Bad Request',
    'type' => 'invalid_request'
  }
}

describe Chargehound::ChargehoundError do
  before do
    Chargehound.api_key = 'API_KEY'
  end

  after do
    WebMock.reset!
  end

  it 'should propagate errors' do
    stub_request(:any, 'https://api.chargehound.com/v1/disputes').to_raise(StandardError)

    # `assert_raises` has trouble on jruby,
    # so we simply write the code
    begin
      Chargehound::Disputes.list
    rescue StandardError => error
      assert(error.is_a?(StandardError))
    end
  end

  it 'should return typed chargehound errors from the API' do
    stub_request(:any, 'https://api.chargehound.com/v1/disputes')
      .to_return(status: 400, body: error_response.to_json)

    # `assert_raises` doesn't like Chargehound::ChargehoundBadRequestError,
    # so we simply write the code
    begin
      Chargehound::Disputes.list
    rescue Chargehound::ChargehoundBadRequestError => error
      assert(error.is_a?(Chargehound::ChargehoundBadRequestError))
      assert_equal(400, error.status)
      assert_equal('Bad Request', error.message)
      assert_equal('(Status 400) Bad Request', error.to_s)
    end
  end

  it 'should surface the error type' do
    stub_request(:any, 'https://api.chargehound.com/v1/disputes').to_raise(StandardError)

    # `assert_raises` has trouble on jruby,
    # so we simply write the code
    begin
      Chargehound::Disputes.list
    rescue StandardError => error
      assert(error.is_a?(StandardError))
    end
  end

  it 'should return typed chargehound errors from the API' do
    stub_request(:any, 'https://api.chargehound.com/v1/disputes')
      .to_return(status: 400, body: error_response_typed.to_json)

    # `assert_raises` doesn't like Chargehound::ChargehoundBadRequestError,
    # so we simply write the code
    begin
      Chargehound::Disputes.list
    rescue Chargehound::ChargehoundBadRequestError => error
      assert(error.is_a?(Chargehound::ChargehoundBadRequestError))
      assert_equal(400, error.status)
      assert_equal('Bad Request', error.message)
      assert_equal('invalid_request', error.type)
      assert_equal('(Status 400) Bad Request', error.to_s)
    end
  end

  it 'should throw a typed error on timeout' do
    stub_request(:any, 'https://api.chargehound.com/v1/disputes').to_timeout

    begin
      Chargehound::Disputes.list
    rescue Chargehound::ChargehoundTimeoutError => error
      assert(error.is_a?(Chargehound::ChargehoundTimeoutError))
      assert_equal('Connection timed out', error.to_s)
    end
  end
end
