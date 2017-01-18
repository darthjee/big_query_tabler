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
        mode: mode
      }
    end

    private

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
      return %w(string integer float boolean).find do |t|
        send("is_#{t}?")
      end || 'string'
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

    def is_boolean?
      value.is_a?(TrueClass) || value.is_a?(FalseClass)
    end
  end
end
