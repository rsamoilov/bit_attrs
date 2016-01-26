module BitAttrs

  class Bitset
    def initialize(flags_map, mask = 0)
      @flags_map = flags_map
      @mask = mask.to_i
    end

    def to_h
      @flags_map.inject({}) do |memo, (flag, _i)|
        memo.merge! flag => self[flag]
      end
    end

    def [](flag)
      i = @flags_map[flag.to_sym]
      bit = (@mask >> i) & 1

      bit == 1
    end

    def []=(flag, value)
      i = @flags_map[flag.to_sym]

      if truthy?(value)
        @mask |= 1 << i
      else
        @mask &= ~(1 << i)
      end
    end

    def inspect
      to_h.inspect
    end

    def to_i
      @mask
    end

    private

    def truthy?(value)
      value == true || value == 'true' || value == '1'
    end
  end

end
