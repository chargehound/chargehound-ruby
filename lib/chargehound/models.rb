require 'ostruct'

module Chargehound
  # Base class for Chargehound models
  class ChargehoundObject < OpenStruct
    def to_json(*a)
      as_json(*a).to_json
    end

    def as_json(*_a)
      hash = {}
      each_pair do |key, value|
        hash[key] = convert(value)
      end
      hash
    end

    def convert(value)
      if value.is_a?(OpenStruct)
        value.as_json
      elsif value.is_a?(Array)
        value.map { |item| convert(item) }
      elsif value.is_a?(Struct)
        value.to_h
      else
        value
      end
    end
  end

  class Dispute < ChargehoundObject
  end

  class Response < ChargehoundObject
  end

  class List < ChargehoundObject
  end

  class Product < ChargehoundObject
  end

  class CorrespondenceItem < ChargehoundObject
  end

  # Expose response properties via this struct on response objects
  HTTPResponse = Struct.new(:status)
end
