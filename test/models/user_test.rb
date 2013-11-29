require 'test_helper'

class UserTest < ActionController::TestCase

  U0 = User.new({
    :user => 'admin', 
    :pass => 'pass', 
    :mail => 'admin@mail.nemonium.com'})
  U1 = User.new({
    :user => 'test1', 
    :pass => '', 
    :mail => 'test1@mail.nemonium.com'})
  U2 = User.new({
    :user => 'test2', 
    :pass => nil, 
    :mail => 'test2@mail.nemonium.com'})
  U3 = User.new({
    :user => '', 
    :pass => 'pass', 
    :mail => 'test3@mail.nemonium.com'})
  U4 = User.new({
    :user => nil, 
    :pass => 'pass', 
    :mail => 'test4@mail.nemonium.com'})
  U5 = User.new({
    :user => 'test5', 
    :pass => 'pass', 
    :mail => ''})
  U6 = User.new({
    :user => 'test6', 
    :pass => 'pass', 
    :mail => nil})

  def test_find
    assert_nil(User.find('dummy'))
    assert_not_nil(User.find('admin'))
    assert_not_nil(User.find('test1'))
    assert_not_nil(User.find('test2'))
    assert_nil(User.find(nil))
    assert_nil(User.find(''))
    assert_not_nil(User.find('test5'))
    assert_not_nil(User.find('test6'))
  end

  def test_user
    assert_equal('admin', U0.user)
    assert_equal('test1', U1.user)
    assert_equal('test2', U2.user)
    assert_equal('',      U3.user)
    assert_equal(nil,     U4.user)
    assert_equal('test5', U5.user)
    assert_equal('test6', U6.user)
  end

  def test_mail
    assert_equal('admin@mail.nemonium.com', U0.mail)
    assert_equal('test1@mail.nemonium.com', U1.mail)
    assert_equal('test2@mail.nemonium.com', U2.mail)
    assert_equal('test3@mail.nemonium.com', U3.mail)
    assert_equal('test4@mail.nemonium.com', U4.mail)
    assert_equal('',                        U5.mail)
    assert_equal(nil,                       U6.mail)
  end

  def test_auth
    # Password => 'pass'
    assert_equal(true,  U0.auth?('pass'))
    assert_equal(false, U0.auth?(''))
    assert_equal(false, U0.auth?(nil))
    # Password => empty
    assert_equal(false, U1.auth?('pass'))
    assert_equal(true,  U1.auth?(''))
    assert_equal(false, U1.auth?(nil))
    # Password => nil
    assert_equal(true,  U2.auth?('pass'))
    assert_equal(true,  U2.auth?(''))
    assert_equal(true,  U2.auth?(nil))
  end

end
