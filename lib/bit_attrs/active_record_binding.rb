module BitAttrs

  class ActiveRecordBinding
    def self.create(klass, attr_name)
      return unless defined?(ActiveRecord)

      klass.define_singleton_method "with_#{attr_name}" do |*flags_list|
        bitset = self.new.send(attr_name)
        flags_list.each { |flag| bitset[flag] = true }

        where("#{attr_name}_mask & ? = ?", bitset.to_i, bitset.to_i)
      end

      klass.define_singleton_method "without_#{attr_name}" do |*flags_list|
        bitset = self.new.send(attr_name)
        flags_list.each { |flag| bitset[flag] = true }

        where("#{attr_name}_mask IS NULL OR #{attr_name}_mask & ? = ?", bitset.to_i, 0)
      end
    end
  end

end
