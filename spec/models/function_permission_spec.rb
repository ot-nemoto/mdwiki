require 'spec_helper'

describe FunctionPermission do
  describe 'main page' do
    before { @fp = FunctionPermission.new(FunctionPermission::MAIN, 'xxx_id') }
    it {
      expect(@fp.create?).to be true
      expect(@fp.save?).to be false
      expect(@fp.preview?).to be false
      expect(@fp.remove?).to be false
      expect(@fp.edit?).to be false
      expect(@fp.cancel?).to be false
      expect(@fp.chk_title?).to be true
      expect(@fp.chk_content?).to be true

      expect(@fp.id).to eq('xxx_id')
      expect(@fp.save_cmd).to be_nil
      expect(@fp.keyword).to be_nil
    }
  end
  describe 'search page' do
    before { @fp = FunctionPermission.new(FunctionPermission::SEARCH, {:keyword => 'search', :chk_title => false, :chk_content => false}) }
    it {
      expect(@fp.create?).to be false
      expect(@fp.save?).to be false
      expect(@fp.preview?).to be false
      expect(@fp.remove?).to be false
      expect(@fp.edit?).to be false
      expect(@fp.cancel?).to be false
      expect(@fp.chk_title?).to be false
      expect(@fp.chk_content?).to be false

      expect(@fp.id).to be_nil
      expect(@fp.save_cmd).to be_nil
      expect(@fp.keyword).to eq('search')
    }
  end
  describe 'show page' do
    before { @fp = FunctionPermission.new(FunctionPermission::SHOW, 'xxx_id') }
    it {
      expect(@fp.create?).to be true
      expect(@fp.save?).to be false
      expect(@fp.preview?).to be false
      expect(@fp.remove?).to be true
      expect(@fp.edit?).to be true
      expect(@fp.cancel?).to be false
      expect(@fp.chk_title?).to be true
      expect(@fp.chk_content?).to be true

      expect(@fp.id).to eq('xxx_id')
      expect(@fp.save_cmd).to be_nil
      expect(@fp.keyword).to be_nil
    }
  end
  describe 'new page' do
    before { @fp = FunctionPermission.new(FunctionPermission::NEW, 'xxx_id') }
    it {
      expect(@fp.create?).to be false
      expect(@fp.save?).to be true
      expect(@fp.preview?).to be true
      expect(@fp.remove?).to be false
      expect(@fp.edit?).to be false
      expect(@fp.cancel?).to be true
      expect(@fp.chk_title?).to be true
      expect(@fp.chk_content?).to be true

      expect(@fp.id).to eq('xxx_id')
      expect(@fp.save_cmd).to eq('insert')
      expect(@fp.keyword).to be_nil
    }
  end
  describe 'edit page' do
    before { @fp = FunctionPermission.new(FunctionPermission::EDIT, 'xxx_id') }
    it {
      expect(@fp.create?).to be false
      expect(@fp.save?).to be true
      expect(@fp.preview?).to be true
      expect(@fp.remove?).to be false
      expect(@fp.edit?).to be false
      expect(@fp.cancel?).to be true
      expect(@fp.chk_title?).to be true
      expect(@fp.chk_content?).to be true

      expect(@fp.id).to eq('xxx_id')
      expect(@fp.save_cmd).to eq('update')
      expect(@fp.keyword).to be_nil
    }
  end
end
