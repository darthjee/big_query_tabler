require 'bidu/core_ext'

class BigExporter
  class Field
    attr_reader :name, :value, :repeat

    def initialize(name, value)
      @name = name
      @repeat = value.is_a?(Array)
      initialize_value(value)
    end

    def as_json
      {
        name: name,
        type: type,
        mode: mode,
        fields: fields
      }.compact
    end

    private

    def fields
      is_record? ? build_fields : nil
    end

    def build_fields
      Structure.new(value).as_json
    end

    def mode
      @mode ||= repeat ? 'REPEATED' : 'NULLABLE'
    end

    def initialize_value(value)
      @value = repeat ? value.first : value
    end

    def type
      @type ||= fetch_type.upcase
    end

    def fetch_type
      return %w(string timestamp integer float boolean record).find do |t|
        send("is_#{t}?")
      end || 'string'
    end

    def is_timestamp?
      is_integer? && value > 1400000000000 && name.match(/date/i)
    end

    def is_integer?
      value.is_a?(Fixnum)
    end

    def is_string?
      value.is_a?(String)
    end

    def is_float?
      value.is_a?(Float)
    end

    def is_record?
      value.is_a?(Hash)
    end

    def is_boolean?
      value.is_a?(TrueClass) || value.is_a?(FalseClass)
    end
  end
end
