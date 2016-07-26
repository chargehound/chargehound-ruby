module Chargehound
  # Cast Chargehound API errors to custom error types
  class ChargehoundError < StandardError
    attr_reader :status, :message

    def initialize(error_response)
      @message = error_response['message']
      @status = error_response['status']
      status_string = @status.nil? ? '' : "(Status #{@status}) "
      super("#{status_string}#{message}")
    end

    def self.create_chargehound_error(error_response)
      error = error_response['error']
      case error['status']
      when 401
        ChargehoundAuthenticationError.new(error)
      when 403
        ChargehoundAuthenticationError.new(error)
      when 400
        ChargehoundBadRequestError.new(error)
      else
        ChargehoundError.new(error)
      end
    end

    def self.create_timeout_error
      ChargehoundTimeoutError.new('Connection timed out')
    end
  end

  class ChargehoundAuthenticationError < ChargehoundError; end
  class ChargehoundBadRequestError < ChargehoundError; end
  class ChargehoundTimeoutError < StandardError; end
end
