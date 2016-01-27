module BitAttrs

  class ActiveRecordBinding
    def self.should_be_created?(klass)
      return false unless defined?(ActiveRecord)
      return false unless klass.ancestors.include?(ActiveRecord::Base)

      true
    end

    def self.with(klass, attr_name, bitset)
      klass.where("#{attr_name}_mask & ? = ?", bitset.to_i, bitset.to_i)
    end

    def self.without(klass, attr_name, bitset)
      klass.where("#{attr_name}_mask IS NULL OR #{attr_name}_mask & ? = ?", bitset.to_i, 0)
    end
  end

end
