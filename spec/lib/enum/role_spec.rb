# encoding: UTF-8
require 'spec_helper'

describe Enum::Role do
  describe 'values' do
    it { expect(Enum::Role.values).to match_array([:READER, :EDITOR, :ADMIN]) }
  end
  describe 'value_of' do
    describe 'nil' do
      it { expect(Enum::Role.value_of(nil)).to eq nil }
    end
    describe 'empty' do
      it { expect(Enum::Role.value_of('')).to eq nil }
    end
    describe 'Not match' do
      it { expect(Enum::Role.value_of('DUMMY')).to eq nil }
    end
    describe 'READER' do
      it { expect(Enum::Role.value_of("READER")).to eq Enum::Role::READER }
    end
  end
end
