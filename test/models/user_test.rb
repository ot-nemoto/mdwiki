require 'test_helper'

class UserTest < ActionController::TestCase

  def setup
    u = Array.new()
    u.push({:user => 'test00', :pass => 'xxx', :mail => 'test00@mail.nemonium.com'})
    u.push({:user => '',       :pass => 'xxx', :mail => 'test01@mail.nemonium.com'})
    u.push({:user => nil,      :pass => 'xxx', :mail => 'test02@mail.nemonium.com'})
    u.push({:user => 'test03', :pass => '',    :mail => 'test03@mail.nemonium.com'})
    u.push({:user => 'test04', :pass => nil,   :mail => 'test04@mail.nemonium.com'})
    u.push({:user => 'test05', :pass => 'xxx', :mail => ''                        })
    u.push({:user => 'test06', :pass => 'xxx', :mail => nil                       })
    USERS.clear()
    USERS.store(:users, u)
  end

  def test_find
    assert_nil(User.find('dummy'))
    assert_not_nil(User.find('test00'))
    assert_nil(User.find(''))
    assert_nil(User.find(nil))
    assert_not_nil(User.find('test03'))
    assert_not_nil(User.find('test04'))
    assert_not_nil(User.find('test05'))
    assert_not_nil(User.find('test06'))
  end

  def test_init01
    u = User.new()
    assert_equal(nil, u.user)
    assert_equal(nil, u.mail)
    assert_equal(false, u.auth?('xxx'))
    assert_equal(false, u.auth?(''))
    assert_equal(false, u.auth?(nil))
  end

  def test_init02
    u = User.new({})
    assert_equal(nil, u.user)
    assert_equal(nil, u.mail)
    assert_equal(false, u.auth?('xxx'))
    assert_equal(false, u.auth?(''))
    assert_equal(false, u.auth?(nil))
  end

  def test_init03
    u = User.new({:user => ''})
    assert_equal('', u.user)
    assert_equal(nil, u.mail)
    assert_equal(false, u.auth?('xxx'))
    assert_equal(false, u.auth?(''))
    assert_equal(false, u.auth?(nil))
  end

  def test_init04
    u = User.new({:user => 'init04'})
    assert_equal('init04', u.user)
    assert_equal(nil, u.mail)
    assert_equal(true, u.auth?('xxx'))
    assert_equal(true, u.auth?(''))
    assert_equal(true, u.auth?(nil))
  end

  def test_init05
    u = User.new({
      :user => 'init05',
      :pass => 'xxx',
      :mail => 'init05@mail.nemonium.com'})
    assert_equal('init05', u.user)
    assert_equal('init05@mail.nemonium.com', u.mail)
    assert_equal(true, u.auth?('xxx'))
    assert_equal(false, u.auth?(''))
    assert_equal(false, u.auth?(nil))
  end

end
