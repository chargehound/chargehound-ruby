require 'base64'
require 'chargehound/error'
require 'chargehound/version'
require 'json'
require 'typhoeus'

module Chargehound
  # Send a request to the Chargehound API
  class ApiRequest
    def initialize(http_method, path, opts = {})
      @request = build_request http_method, path, opts
    end

    def run
      response = @request.run

      body = parse_request_body response.body

      unless response.success?
        raise ChargehoundError.create_chargehound_error body
      end

      body
    end

    def build_headers(opts)
      headers = {
        'Accept' => 'application/json',
        'Authorization' =>
          "Basic #{Base64.encode64(Chargehound.api_key + ':').chomp}",
        'User-Agent' => "Chargehound/v1 RubyBindings/#{VERSION}"
      }
      opts[:body] && headers['Content-Type'] = 'application/json'
      headers
    end

    def build_body(req_opts, http_method, opts)
      if [:post, :patch, :put, :delete].include? http_method
        req_body = build_request_body opts[:body]
        req_opts.update body: req_body
      end
    end

    def build_opts(http_method, opts)
      query_params = opts[:query_params] || {}
      headers = build_headers opts
      req_opts = {
        method: http_method,
        headers: headers,
        params: query_params
      }
      build_body req_opts, http_method, opts
      req_opts
    end

    def build_request(http_method, path, opts = {})
      url = build_request_url path
      http_method = http_method.to_sym.downcase
      req_opts = build_opts http_method, opts

      Typhoeus::Request.new(url, req_opts)
    end

    def build_request_url(path)
      'https://' + Chargehound.host + Chargehound.base_path + path
    end

    def build_request_body(body)
      body.to_json
    end

    def parse_request_body(body)
      JSON.parse body
    end
  end
end
