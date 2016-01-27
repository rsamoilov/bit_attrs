require "bit_attrs/bindings/active_record_binding"
require "bit_attrs/bindings/data_mapper_binding"

module BitAttrs

  class Bindings
    ORM_BINDINGS = [ActiveRecordBinding, DataMapperBinding]

    def self.create(klass, attr_name)
      ORM_BINDINGS.each do |orm_binding|
        next unless orm_binding.should_be_created?(klass)

        klass.define_singleton_method "with_#{attr_name}" do |*flags_list|
          bitset = self.new.send(attr_name)
          flags_list.each { |flag| bitset[flag] = true }

          orm_binding.with(klass, attr_name, bitset)
        end

        klass.define_singleton_method "without_#{attr_name}" do |*flags_list|
          bitset = self.new.send(attr_name)
          flags_list.each { |flag| bitset[flag] = true }

          orm_binding.without(klass, attr_name, bitset)
        end
      end
    end
  end

end
