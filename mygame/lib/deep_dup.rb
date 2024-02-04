module DeepDup
  class << self
    def dup(obj)
      case obj
      when Array
        obj.map { |item| dup(item) }
      when Hash
        obj.transform_values { |value| dup(value) }
      when Numeric, Symbol, TrueClass, FalseClass, NilClass
        obj
      else
        obj.dup
      end
    end

    def raise_unless_duppable!(value)
      case value
      when Array, Hash
        DuppableChecker.new(value).check!
      end
    end
  end

  class DuppableChecker
    def initialize(value)
      @value = value
      @object_ids = {}
    end

    def check!
      check_recursive_references!(@value)
    end

    private

    def check_recursive_references!(value)
      case value
      when Array
        raise_if_object_id_seen_before!(value)
        @object_ids[value.object_id] = true
        value.each { |item| check_recursive_references!(item) }
      when Hash
        raise_if_object_id_seen_before!(value)
        @object_ids[value.object_id] = true
        value.each { |key, item|
          check_recursive_references!(key)
          check_recursive_references!(item)
        }
      end
    end

    def raise_if_object_id_seen_before!(value)
      return unless @object_ids.key?(value.object_id)

      raise ArgumentError, "Value #{value} is not deep duppable (contains recursive references)"
    end
  end
end
