class ComponentDefinitions
  def initialize
    @definitions = {}
  end

  def define(name, &block)
    @definitions[name] = Module.new do
      @name = name
      extend Component
    end
    @definitions[name].class_eval(&block)
  end

  def [](name)
    @definitions[name]
  end

  def defined_types
    @definitions.keys
  end

  def clear
    @definitions = {}
  end
end
