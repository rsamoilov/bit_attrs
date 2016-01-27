require 'test_helper'

class ActiveRecordBindingTest < Minitest::Test
  module ActiveRecord
    module Base
    end
  end

  User = Struct.new(:name, :roles_mask, :access_mask) do
    include ActiveRecord::Base
    include BitAttrs
  end

  def setup
    Object.const_set :ActiveRecord, ActiveRecord
    User.bitset roles: [:admin, :user, :guest], access: [:read, :write]
  end

  def teardown
    Object.send :remove_const, :ActiveRecord
  end

  def test_ar_methods_added
    assert_respond_to User, :with_roles
    assert_respond_to User, :without_roles
    assert_respond_to User, :with_access
    assert_respond_to User, :without_access
  end

  def test_with_roles
    User.expects(:where).with("roles_mask & ? = ?", 1, 1).returns(User)
    User.with_roles(:admin)
  end

  def test_with_different_roles
    User.expects(:where).with("roles_mask & ? = ?", 3, 3).returns(User)
    User.with_roles(:admin, :user)
  end

  def test_without_different_roles
    User.expects(:where).with("roles_mask IS NULL OR roles_mask & ? = ?", 6, 0).returns(User)
    User.without_roles(:guest, :user)
  end

  def test_different_with_conditions
    User.expects(:where).with("roles_mask & ? = ?", 3, 3).returns(User)
    User.expects(:where).with("access_mask & ? = ?", 2, 2).returns(User)
    User.with_roles(:admin, :user).with_access(:write)
  end

  def test_different_with_and_without_conditions
    User.expects(:where).with("roles_mask & ? = ?", 5, 5).returns(User)
    User.expects(:where).with("access_mask & ? = ?", 1, 1).returns(User)
    User.expects(:where).with("access_mask IS NULL OR access_mask & ? = ?", 2, 0).returns(User)
    User.with_roles(:admin, :guest).with_access(:read).without_access(:write)
  end
end
