module BitAttrs

  class DataMapperBinding
    def self.should_be_created?(klass)
      return false unless defined?(DataMapper::Resource)
      return false unless klass.included_modules.include?(DataMapper::Resource)

      true
    end

    def self.with(klass, attr_name, bitset)
      klass.all(conditions: ["#{attr_name}_mask & ? = ?", bitset.to_i, bitset.to_i])
    end

    def self.without(klass, attr_name, bitset)
      klass.all(conditions: ["#{attr_name}_mask IS NULL OR #{attr_name}_mask & ? = ?", bitset.to_i, 0])
    end
  end

end
