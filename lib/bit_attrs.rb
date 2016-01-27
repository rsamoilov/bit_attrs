require "bit_attrs/bitset"
require "bit_attrs/version"
require "bit_attrs/bindings"

module BitAttrs

  def self.included(klass)
    klass.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    attr_reader :bit_attrs

    # bitset roles: [:admin, :user, :guest]
    # bitset access_levels: [read: 0, write: 1, delete: 2, api: 3]
    def bitset(flags_map)
      @bit_attrs ||= {}

      flags_map.each do |attr_name, flags_list|
        @bit_attrs[attr_name] = check_flags_list(flags_list)
        define_alias_methods(attr_name, @bit_attrs[attr_name])
        Bindings.create(self, attr_name)
      end
    end

    private

    def check_flags_list(flags_list)
      return flags_list if flags_list.is_a?(Hash)

      flags_list.each_with_index.inject({}) do |memo, (flag, i)|
        memo.merge!(flag => i)
      end
    end

    def define_alias_methods(attr_name, flags_map)
      define_method attr_name do
        Bitset.new(flags_map, self.send("#{attr_name}_mask"))
      end

      define_method "#{attr_name}=" do |flags_map|
        bitset = self.class.new.send(attr_name)
        flags_map.each { |flag, bool| bitset[flag] = bool }
        self.send("#{attr_name}_mask=", bitset.to_i)
      end

      flags_map.each do |flag, _i|
        define_method(flag) { self.send(attr_name)[flag] }
        define_method("#{flag}?") { self.send(flag) }
      end
    end
  end

end
