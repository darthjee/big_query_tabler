require './big_exporter/field'

class BigExporter
  class Structure
    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    def as_json
        @as_json ||= hash.map do |key, value|
        Field.new(key, value).as_json
      end
    end

    def to_json
      as_json.to_json
    end
  end
end
