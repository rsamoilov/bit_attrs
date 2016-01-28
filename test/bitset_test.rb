require 'test_helper'

class BitsetTest < Minitest::Test
  def setup
    @bitset = BitAttrs::Bitset.new({ admin: 0, user: 1, guest: 2 }, nil)
  end

  def test_mask_defaults_to_zero
    assert_equal({ admin: false, user: false, guest: false }, @bitset.to_h)
    assert_equal 0, @bitset.to_i
  end

  def test_mask_is_handled_on_creation
    bitset = BitAttrs::Bitset.new({ read: 2, write: 3 }, 8)
    assert_equal( { read: false, write: true }, bitset.to_h)
  end

  def test_setting_flags
    @bitset[:admin] = '1'
    assert_equal '1', @bitset.to_i.to_s(2)

    @bitset[:guest] = 'true'
    assert_equal '101', @bitset.to_i.to_s(2)

    @bitset[:user] = true
    assert_equal '111', @bitset.to_i.to_s(2)
  end

  def test_getting_flags
    @bitset[:guest] = true
    assert @bitset[:guest]
    assert_equal({ admin: false, user: false, guest: true }, @bitset.to_h)

    @bitset[:user] = true
    assert @bitset[:user]
    assert_equal({ admin: false, user: true, guest: true }, @bitset.to_h)
  end

  def test_unsetting_flags
    @bitset[:admin] = @bitset[:user] = @bitset[:guest] = true

    @bitset[:user] = false
    refute @bitset[:user]
    assert_equal({ admin: true, user: false, guest: true }, @bitset.to_h)
  end

  def test_custom_indexes
    bitset = BitAttrs::Bitset.new({ admin: 2, user: 4, guest: 6 })
    bitset[:user] = true
    assert bitset[:user]
    assert_equal({ admin: false, user: true, guest: false }, bitset.to_h)
    assert_equal '10000', bitset.to_i.to_s(2)

    bitset[:admin] = bitset[:guest] = true
    assert_equal({ admin: true, user: true, guest: true }, bitset.to_h)
    assert_equal '1010100', bitset.to_i.to_s(2)
  end

  def test_each
    assert_instance_of Enumerator, @bitset.each
    assert_equal 3, @bitset.each.size
    @bitset[:user] = true

    @bitset.each { |flag, bool| assert_equal bool, @bitset[flag] }
  end
end
