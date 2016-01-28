require 'test_helper'

class BitAttrsTest < Minitest::Test
  User = Struct.new(:name, :roles_mask) do
    include BitAttrs
    bitset roles: [:admin, :user, :guest]
  end

  def setup
    @user = User.new('test user')
  end

  def test_bit_attrs_initialized
    assert_equal({ admin: 0, user: 1, guest: 2 }, User.bit_attrs[:roles])
    refute_respond_to User, :with_roles
    refute_respond_to User, :without_roles

    assert_respond_to @user, :roles
    assert_respond_to @user, "roles=".to_sym
    [:admin, :user, :guest].each do |flag|
      assert_respond_to(@user, flag) && assert_respond_to(@user, "#{flag}?")
    end
  end

  def test_bitset_is_returned
    assert_instance_of BitAttrs::Bitset, @user.roles
  end

  def test_bitset_is_not_cached
    assert_equal({ admin: false, user: false, guest: false }, @user.roles.to_h)
    @user.roles_mask = 5
    assert_equal({ admin: true, user: false, guest: true }, @user.roles.to_h)
  end

  def test_bitset_is_assigned_correctly
    @user.roles = { admin: true, user: true, guest: true }
    assert_equal 7, @user.roles_mask

    @user.roles = { user: true }
    assert_equal 2, @user.roles_mask
  end

  def test_single_assignment
    @user.guest = true
    assert_equal({ admin: false, user: false, guest: true }, @user.roles.to_h)

    @user.admin = true
    assert_equal({ admin: true, user: false, guest: true }, @user.roles.to_h)
  end

  def test_one_can_assign_bitset
    new_bitset = User.new.roles
    new_bitset[:guest] = true
    @user.roles = new_bitset

    assert_equal({ admin: false, user: false, guest: true }, @user.roles.to_h)
  end

  AccessUser = Struct.new(:name, :access_mask) do
    include BitAttrs
    bitset access: { read: 5, write: 10 }
  end

  def test_hash_flags_are_handled_correctly
    user = AccessUser.new
    assert_equal({ read: 5, write: 10 }, AccessUser.bit_attrs[:access])

    user.access = { read: true, write: true }
    assert_equal 2 ** 5 + 2 ** 10, user.access_mask
  end

  def test_hash_flags_are_set_correctly
    user = AccessUser.new
    user.access = { read: true }

    assert user.read
    assert_equal({ read: true, write: false }, user.access.to_h)
  end

  TestUser = Struct.new(:roles_mask, :access_mask, :rights_mask) do
    include BitAttrs
    bitset roles: [:admin, :user], access: { read: 1, write: 2 }
    bitset rights_mask: [:create, :update]
  end

  def test_different_flags_are_supported
    assert_equal [:roles, :access, :rights_mask], TestUser.bit_attrs.keys
  end
end
