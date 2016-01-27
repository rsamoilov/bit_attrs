require 'test_helper'

class DataMapperBindingTest < Minitest::Test
  module DataMapper
    module Resource
    end
  end

  User = Struct.new(:name, :roles_mask) do
    include DataMapper::Resource
    include BitAttrs
  end

  def setup
    Object.const_set :DataMapper, DataMapper
    User.bitset roles: [:admin, :user, :guest]
  end

  def teardown
    Object.send :remove_const, :DataMapper
  end

  def test_dm_methods_added
    assert_respond_to User, :with_roles
    assert_respond_to User, :without_roles
  end

  def test_with_roles
    User.expects(:all).with(conditions: ["roles_mask & ? = ?", 1, 1]).returns(User)
    User.with_roles(:admin)
  end

  def test_without_roles
    User.expects(:all).with(conditions: ["roles_mask & ? = ?", 2, 2]).returns(User)
    User.expects(:all).with(conditions: ["roles_mask IS NULL OR roles_mask & ? = ?", 5, 0]).returns(User)
    User.with_roles(:user).without_roles(:admin, :guest)
  end
end
