require 'chargehound/disputes'
require 'chargehound/error'

# Chargehound Ruby bindings
module Chargehound
  @host = 'api.chargehound.com'
  @base_path = '/v1/'
  @api_key = ''

  class << self
    attr_accessor :api_key, :host, :base_path
  end
end
