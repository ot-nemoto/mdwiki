require 'spec_helper'

describe User do

  before {
    @ul = Array.new
    @ul.push({:user => 'test01', :pass => Digest::SHA256.hexdigest('passwd'), :mail => 'test00@mail.nemonium.com', :role => 'admin'})
  }

  describe 'auth?' do
    describe 'not user' do
      before { @u = User.new({:user => nil, :pass => Digest::SHA256.hexdigest('passwd')}) }
      it { expect(@u.auth?('passwd')).to be false }
    end
    describe 'user is empty' do
      before { @u = User.new({:user => '', :pass => Digest::SHA256.hexdigest('passwd')}) }
      it { expect(@u.auth?('passwd')).to be false }
    end
    describe 'No password' do
      before { @u = User.new({:user => 'test01', :pass => nil}) }
      it { expect(@u.auth?('passwd')).to be true }
    end
    describe 'No input password' do
      before { @u = User.new({:user => 'test01', :pass => Digest::SHA256.hexdigest('passwd')}) }
      it { expect(@u.auth?(nil)).to be false }
    end
    describe 'Auth failed' do
      before { @u = User.new({:user => 'test01', :pass => Digest::SHA256.hexdigest('passwd')}) }
      it { expect(@u.auth?('passwx')).to be false }
    end
    describe 'Auth success' do
      before { @u = User.new({:user => 'test01', :pass => Digest::SHA256.hexdigest('passwd')}) }
      it { expect(@u.auth?('passwd')).to be true }
    end
  end

  describe 'role' do
    describe 'nil' do
      before { @u = User.new({:role => nil}) }
      it { expect(@u.role).to eq(Enum::Role::READER) }
    end
    describe 'empty' do
      before { @u = User.new({:role => ''}) }
      it { expect(@u.role).to eq(Enum::Role::READER) }
    end
    describe 'not exist role' do
      before { @u = User.new({:role => 'tester'}) }
      it { expect(@u.role).to eq(Enum::Role::READER) }
    end
    describe 'exist role' do
      before { @u = User.new({:role => 'editor'}) }
      it { expect(@u.role).to eq(Enum::Role::EDITOR) }
    end
  end

  describe 'find' do
    describe 'nil' do
      it { expect(User.find(nil, @ul)).to be_nil }
    end
    describe 'empty' do
      it { expect(User.find('', @ul)).to be_nil }
    end
    describe 'not exist user' do
      it { expect(User.find('test00', @ul)).to be_nil }
    end
    describe 'exist user' do
      it {
        actual = User.find('test01', @ul)
        expect(actual).to be_an_instance_of(User)
        expect(actual.user).to eq('test01')
        expect(actual.mail).to eq('test00@mail.nemonium.com')
        expect(actual.role).to eq(Enum::Role::ADMIN)
      }
    end
  end
end
