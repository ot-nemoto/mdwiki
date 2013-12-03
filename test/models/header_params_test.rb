require 'test_helper'

class HeaderParamsTest < ActionController::TestCase

  def test_type_main
    mp = HeaderParams.new(HeaderParams::MAIN, 'xxxxx')
    assert_equal(true, mp.create?)
    assert_equal(false, mp.save?)
    assert_equal(false, mp.preview?)
    assert_equal(false, mp.remove?)
    assert_equal(false, mp.edit?)
    assert_equal(false, mp.cancel?)
    assert_equal('xxxxx', mp.id)
    assert_equal(nil, mp.save_cmd)
    assert_equal(nil, mp.keyword)
    assert_equal(true, mp.chk_title?)
    assert_equal(true, mp.chk_content?)
  end

  def test_type_search
    mp = HeaderParams.new(HeaderParams::SEARCH, {
      :keyword => 'xxxxx', 
      :chk_title => false, 
      :chk_content => false})
    assert_equal(false, mp.create?)
    assert_equal(false, mp.save?)
    assert_equal(false, mp.preview?)
    assert_equal(false, mp.remove?)
    assert_equal(false, mp.edit?)
    assert_equal(false, mp.cancel?)
    assert_equal(nil, mp.id)
    assert_equal(nil, mp.save_cmd)
    assert_equal('xxxxx', mp.keyword)
    assert_equal(false, mp.chk_title?)
    assert_equal(false, mp.chk_content?)
  end

  def test_type_show
    mp = HeaderParams.new(HeaderParams::SHOW, 'xxxxx')
    assert_equal(true, mp.create?)
    assert_equal(false, mp.save?)
    assert_equal(false, mp.preview?)
    assert_equal(true, mp.remove?)
    assert_equal(true, mp.edit?)
    assert_equal(false, mp.cancel?)
    assert_equal('xxxxx', mp.id)
    assert_equal(nil, mp.save_cmd)
    assert_equal(nil, mp.keyword)
    assert_equal(true, mp.chk_title?)
    assert_equal(true, mp.chk_content?)
  end

  def test_type_new
    mp = HeaderParams.new(HeaderParams::NEW, 'xxxxx')
    assert_equal(false, mp.create?)
    assert_equal(true, mp.save?)
    assert_equal(true, mp.preview?)
    assert_equal(false, mp.remove?)
    assert_equal(false, mp.edit?)
    assert_equal(true, mp.cancel?)
    assert_equal('xxxxx', mp.id)
    assert_equal('insert', mp.save_cmd)
    assert_equal(nil, mp.keyword)
    assert_equal(true, mp.chk_title?)
    assert_equal(true, mp.chk_content?)
  end

  def test_type_edit
    mp = HeaderParams.new(HeaderParams::EDIT, 'xxxxx')
    assert_equal(false, mp.create?)
    assert_equal(true, mp.save?)
    assert_equal(true, mp.preview?)
    assert_equal(false, mp.remove?)
    assert_equal(false, mp.edit?)
    assert_equal(true, mp.cancel?)
    assert_equal('xxxxx', mp.id)
    assert_equal('update', mp.save_cmd)
    assert_equal(nil, mp.keyword)
    assert_equal(true, mp.chk_title?)
    assert_equal(true, mp.chk_content?)
  end

end
