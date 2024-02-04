def deep_dup(obj)
  case obj
  when Array
    obj.map { |item| deep_dup(item) }
  when Hash
    obj.transform_values { |value| deep_dup(value) }
  when Numeric, Symbol, TrueClass, FalseClass, NilClass
    obj
  else
    obj.dup
  end
end
