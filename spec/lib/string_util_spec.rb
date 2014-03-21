# encoding: UTF-8
require 'spec_helper'

describe StringUtil do
  describe 'nil' do
    it { expect(StringUtil.blank?(nil)).to be true }
  end
  describe 'empty' do
    it { expect(StringUtil.blank?('')).to be true }
  end
  describe 'space' do
    it { expect(StringUtil.blank?(' ')).to be true }
  end
  describe 'em space' do
    it { expect(StringUtil.blank?('　')).to be true }
  end
  describe 'ascii' do
    it { expect(StringUtil.blank?('A')).to be false }
  end
  describe 'em' do
    it { expect(StringUtil.blank?('Ａ')).to be false }
  end
end
