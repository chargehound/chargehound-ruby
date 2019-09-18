require 'chargehound/models'
require 'chargehound/error'
require 'chargehound/version'
require 'json'
require 'net/http'

module Chargehound
  # Send a request to the Chargehound API
  class ApiRequest
    def initialize(http_method, path, opts = {})
      @request = build_request http_method, path, opts
    end

    def run
      host = @request.uri.host
      port = @request.uri.port
      Net::HTTP.start(host, port, build_http_opts) do |http|
        begin
          response = http.request @request
          handle_response response
        rescue Net::ReadTimeout
          raise ChargehoundError.create_timeout_error
        rescue Timeout::Error
          raise ChargehoundError.create_timeout_error
        end
      end
    end

    def handle_response(response)
      case response
      when Net::HTTPSuccess
        parse_response response
      when Net::HTTPRequestTimeOut
        raise ChargehoundError.create_timeout_error
      else
        body = JSON.parse response.body
        raise ChargehoundError.create_chargehound_error body
      end
    end

    def build_http_opts
      { use_ssl: true, read_timeout: Chargehound.timeout }
    end

    def build_headers(body)
      headers = {
        'Accept' => 'application/json',
        'User-Agent' => "Chargehound/v1 RubyBindings/#{VERSION}"
      }
      unless Chargehound.version.nil?
        headers['Chargehound-Version'] = Chargehound.version
      end
      body && headers['Content-Type'] = 'application/json'
      headers
    end

    def build_body(body)
      body.to_json if body
    end

    def build_request_instance(http_method, uri, body, headers)
      case http_method
      when :get
        Net::HTTP::Get.new uri, headers
      when :put
        req = Net::HTTP::Put.new uri, headers
        req.body = body
        req
      when :post
        req = Net::HTTP::Post.new uri, headers
        req.body = body
        req
      end
    end

    def build_request(http_method, path, opts = {})
      query_params = opts[:query_params] || {}
      body = opts[:body]
      http_method = http_method.to_sym.downcase

      uri = build_uri path, query_params
      headers = build_headers body
      body = build_body body

      req = build_request_instance http_method, uri, body, headers
      req.basic_auth Chargehound.api_key, ''
      req
    end

    def build_uri(path, query_params)
      url = 'https://' + Chargehound.host + Chargehound.base_path + path
      uri = URI(url)
      uri.query = URI.encode_www_form(query_params)
      uri
    end

    def convert(dict)
      case dict['object']
      when 'dispute'
        dict['products'] = dict.fetch('products', []).map { |item|
          Product.new(item)
        }
        dict['correspondence'] = dict.fetch('correspondence', []).map { |item|
          CorrespondenceItem.new(item)
        }
        dict['past_payments'] = dict.fetch('past_payments', []).map { |item|
          PastPayment.new(item)
        }
        Dispute.new(dict)
      when 'list'
        dict['data'].map! { |item| convert item }
        list = List.new(dict)
        list
      when 'response'
        Response.new(dict)
      else
        ChargehoundObject.new
      end
    end

    def parse_response(response)
      body = JSON.parse response.body
      body = convert body
      body.response = HTTPResponse.new(response.code)
      body
    end
  end
end
