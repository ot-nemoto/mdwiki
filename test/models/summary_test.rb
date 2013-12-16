require 'test_helper'

class SummaryTest < ActionController::TestCase

  def setup
    SUMMARIES.clear()
    SUMMARIES.store(:"id00000001", {
      :title => 'Title01', 
      :parent => 'ROOT',
      :create_user => 'user1',
      :create_date => '2013-11-20 22:22:22',
      :update_user => 'user2',
      :update_date => '2013-11-22 23:33:33'
    })
  end

  def test_init01
    s = Summary.new()
    assert_nil(s.id)
    assert_nil(s.title)
    assert_nil(s.parent)
    assert_nil(s.create_user)
    assert_nil(s.create_date)
    assert_nil(s.update_user)
    assert_nil(s.update_date)
  end

  def test_init02
    s = Summary.new(nil)
    assert_nil(s.id)
    assert_nil(s.title)
    assert_nil(s.parent)
    assert_nil(s.create_user)
    assert_nil(s.create_date)
    assert_nil(s.update_user)
    assert_nil(s.update_date)
  end

  def test_init03
    s = Summary.new('')
    assert_equal('', s.id)
    assert_nil(s.title)
    assert_nil(s.parent)
    assert_nil(s.create_user)
    assert_nil(s.create_date)
    assert_nil(s.update_user)
    assert_nil(s.update_date)
  end

  def test_init04
    s = Summary.new('id00000001')
    assert_equal('id00000001', s.id)
    assert_equal('Title01', s.title)
    assert_equal('ROOT', s.parent)
    assert_equal('user1', s.create_user)
    assert_equal('2013-11-20 22:22:22', s.create_date)
    assert_equal('user2', s.update_user)
    assert_equal('2013-11-22 23:33:33', s.update_date)
  end

  def test_init05
    s = Summary.new('id00000002')
    assert_equal('id00000002', s.id)
    assert_nil(s.title)
    assert_nil(s.parent)
    assert_nil(s.create_user)
    assert_nil(s.create_date)
    assert_nil(s.update_user)
    assert_nil(s.update_date)
  end

end
