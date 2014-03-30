# encoding: UTF-8
require 'spec_helper'

describe StringUtil do
  describe 'blank?' do
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

  describe 'trim' do
    describe 'nil' do
      it { expect(StringUtil.trim(nil)).to be_nil }
    end
    describe 'space' do
      it { expect(StringUtil.trim('  ')).to eq '' }
      it { expect(StringUtil.trim(' xxx ')).to eq 'xxx' }
    end
    describe 'em space' do
      it { expect(StringUtil.trim('　　')).to eq '' }
      it { expect(StringUtil.trim('　xxx　')).to eq 'xxx' }
    end
  end

  describe 'exist?' do
    describe 'keyword is nil' do
      it {
        expect(StringUtil.exist?(nil, nil)).to be false
        expect(StringUtil.exist?('', nil)).to be false
        expect(StringUtil.exist?(' ', nil)).to be false
        expect(StringUtil.exist?('　', nil)).to be false
        expect(StringUtil.exist?('ABCDＥＦＧＨ', nil)).to be false
        expect(StringUtil.exist?('ＡＢＣＤDFGH', nil)).to be false
      }
    end
    describe 'keyword is empty' do
      it {
        expect(StringUtil.exist?(nil, '')).to be false
        expect(StringUtil.exist?('', '')).to be false
        expect(StringUtil.exist?(' ', '')).to be false
        expect(StringUtil.exist?('　', '')).to be false
        expect(StringUtil.exist?('ABCDＥＦＧＨ', '')).to be false
        expect(StringUtil.exist?('ＡＢＣＤDFGH', '')).to be false
      }
    end
    describe 'keyword is ascii' do
      it {
        expect(StringUtil.exist?(nil, 'BC')).to be false
        expect(StringUtil.exist?('', 'BC')).to be false
        expect(StringUtil.exist?(' ', 'BC')).to be false
        expect(StringUtil.exist?('　', 'BC')).to be false
        expect(StringUtil.exist?('ABCDＥＦＧＨ', 'BC')).to be true
        expect(StringUtil.exist?('ＡＢＣＤDFGH', 'BC')).to be false
      }
    end
    describe 'keyword is em' do
      it {
        expect(StringUtil.exist?(nil, 'ＢＣ')).to be false
        expect(StringUtil.exist?('', 'ＢＣ')).to be false
        expect(StringUtil.exist?(' ', 'ＢＣ')).to be false
        expect(StringUtil.exist?('　', 'ＢＣ')).to be false
        expect(StringUtil.exist?('ABCDＥＦＧＨ', 'ＢＣ')).to be false
        expect(StringUtil.exist?('ＡＢＣＤDFGH', 'ＢＣ')).to be true
      }
    end
    describe 'keyword is multi' do
      describe 'split is ascii space' do
        it {
          expect(StringUtil.exist?('ABCDＥＦＧＨ', 'BC ＦＧ')).to be true
          expect(StringUtil.exist?('ABCDＥＦＧＨ', 'BC  ＦＧ')).to be true
        }
      end
      describe 'split is em aspce' do
      it {
        expect(StringUtil.exist?('ABCDＥＦＧＨ', 'BC　ＦＧ')).to be true
        expect(StringUtil.exist?('ABCDＥＦＧＨ', 'BC　　ＦＧ')).to be true
      }
      end
      describe 'or condition' do
        it { expect(StringUtil.exist?('ABCDＥＦＧＨ', 'BC FG')).to be false }
      end
    end
  end
end
