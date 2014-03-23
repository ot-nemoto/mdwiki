# encoding: UTF-8
require 'spec_helper'

describe Summary do

  describe 'parents' do
    before {
      @summaries = {
        :www => {:title => '4-title', :parent => 'ROOT'},
        :xxx => {:title => '3-title', :parent => 'www'},
        :yyy => {:title => '2-title', :parent => 'xxx'},
        :zzz => {:title => '1-title', :parent => 'xxx'}
      }
    }
    describe 'parents not exist' do
      before { @summary = Summary.new('www', nil, @summaries) }
      it { expect(@summary.parents).to match_array([]) }
    end
    describe 'parent exist' do
      before { @summary = Summary.new('xxx', nil, @summaries) }
      it {
        actual = @summary.parents
        expect(actual.size).to eq(1)
        expect(actual[0].id).to eq(:www)
      }
    end
    describe 'some generation parent exist' do
      before { @summary = Summary.new('yyy', nil, @summaries) }
      it {
        actual = @summary.parents
        expect(actual.size).to eq(2)
        # sorted by from ROOT
        expect(actual[0].id).to eq(:www)
        expect(actual[1].id).to eq(:xxx)
      }
    end
  end

  describe 'children' do
    before {
      @summaries = {
        :www => {:title => '4-title', :parent => 'ROOT'},
        :xxx => {:title => '3-title', :parent => 'www'},
        :yyy => {:title => '2-title', :parent => 'xxx'},
        :zzz => {:title => '1-title', :parent => 'xxx'}
      }
    }
    describe 'child not exist' do
      before { @summary = Summary.new('yyy', nil, @summaries) }
      it { expect(@summary.children).to match_array([]) }
    end
    describe 'child exist' do
      before { @summary = Summary.new('www', nil, @summaries) }
      it {
        actual = @summary.children
        expect(actual.size).to eq(1)
        expect(actual[0].id).to eq(:xxx)
      }
    end
    describe 'children exist' do
      before { @summary = Summary.new('xxx', nil, @summaries) }
      it {
        actual = @summary.children
        expect(actual.size).to eq(2)
        # sorted by title
        expect(actual[0].id).to eq(:zzz)
        expect(actual[1].id).to eq(:yyy)
      }
    end
  end

  describe 'children_exist?' do
    before {
      @summaries = {
        :www => {:title => '4-title', :parent => 'ROOT'},
        :xxx => {:title => '3-title', :parent => 'www'},
        :yyy => {:title => '2-title', :parent => 'xxx'},
        :zzz => {:title => '1-title', :parent => 'xxx'}
      }
    }
    describe 'child not exist' do
      before { @summary = Summary.new('yyy', nil, @summaries) }
      it { expect(@summary.children_exist?).to be false }
    end
    describe 'child exist' do
      before { @summary = Summary.new('www', nil, @summaries) }
      it { expect(@summary.children_exist?).to be true }
    end
    describe 'children exist' do
      before { @summary = Summary.new('xxx', nil, @summaries) }
      it { expect(@summary.children_exist?).to be true }
    end
  end

  describe 'update' do
    before {
      File.open("summary_file_rspec", "w").close()
      @summary_path = Pathname("summary_file_rspec")
      @summaries    = {
        :xxx => {:title => '', :parent => '', :create_user => '', :create_date => '', :update_user => '', :update_date => ''},
        :yyy => {:title => '', :parent => '', :create_user => '', :create_date => '', :update_user => '', :update_date => ''}
      }
      File.open(@summary_path, mode = 'w') { |f| JSON.dump(@summaries, f) }
      @summary      = Summary.new('xxx', @summary_path, @summaries)
    }
    it {
      expect(File.open("summary_file_rspec").read).to eq('{"xxx":{"title":"","parent":"","create_user":"","create_date":"","update_user":"","update_date":""},"yyy":{"title":"","parent":"","create_user":"","create_date":"","update_user":"","update_date":""}}')
      expect(@summaries).to eq({
        :xxx => {:title => '', :parent => '', :create_user => '', :create_date => '', :update_user => '', :update_date => ''},
        :yyy => {:title => '', :parent => '', :create_user => '', :create_date => '', :update_user => '', :update_date => ''}
      })
      @summary.title = 'x'
      @summary.parent = 'x'
      @summary.create_user = 'x'
      @summary.create_date = 'x'
      @summary.update_user = 'x'
      @summary.update_date = 'x'
      @summary.update
      expect(File.open("summary_file_rspec").read).to eq('{"xxx":{"title":"","parent":"","create_user":"","create_date":"","update_user":"","update_date":""},"yyy":{"title":"","parent":"","create_user":"","create_date":"","update_user":"","update_date":""}}')
      expect(@summaries).to eq({
        :xxx => {:title => 'x', :parent => 'x', :create_user => 'x', :create_date => 'x', :update_user => 'x', :update_date => 'x'},
        :yyy => {:title => '', :parent => '', :create_user => '', :create_date => '', :update_user => '', :update_date => ''}
      })
    }
  end

  describe 'remove' do
    before {
      File.open("summary_file_rspec", "w").close()
      @summary_path = Pathname("summary_file_rspec")
      @summaries    = {:xxx => {}, :yyy => {}, :zzz => {}}
      File.open(@summary_path, mode = 'w') { |f| JSON.dump(@summaries, f) }
      @summary      = Summary.new('xxx', @summary_path, @summaries)
    }
    it {
      expect(File.open("summary_file_rspec").read).to eq('{"xxx":{},"yyy":{},"zzz":{}}')
      expect(@summaries).to eq({:xxx => {}, :yyy => {}, :zzz => {}})
      @summary.remove
      expect(File.open("summary_file_rspec").read).to eq('{"xxx":{},"yyy":{},"zzz":{}}')
      expect(@summaries).to eq({:yyy => {}, :zzz => {}})
    }
  end

  describe 'commit' do
    before {
      File.open("summary_file_rspec", "w").close()
      @summary_path = Pathname("summary_file_rspec")
      @summaries    = {:xxx => {}, :yyy => {}, :zzz => {}}
      @summary      = Summary.new('xxx', @summary_path, @summaries)
    }
    it {
      expect(File.open("summary_file_rspec").read).to eq('')
      expect(@summaries).to eq({:xxx => {}, :yyy => {}, :zzz => {}})
      @summary.commit
      expect(File.open("summary_file_rspec").read).to eq('{"xxx":{},"yyy":{},"zzz":{}}')
      expect(@summaries).to eq({:xxx => {}, :yyy => {}, :zzz => {}})
    }
  end

  describe 'ids' do
    before { @summaries = {:xxx => {}, :yyy => {}, :zzz => {}} }
    it { expect(Summary.ids(@summaries)).to match_array([:xxx, :yyy, :zzz]) }
  end

  describe 'exist?' do
    before { @summaries = {:xxx => {}, :xx0 => {}, '0xx'.to_sym => {}, '000'.to_sym => {}} }
    describe 'nil' do
      it { expect(Summary.exist?(nil, @summaries)).to be false }
    end
    describe 'not exist' do
      it { expect(Summary.exist?('yyy', @summaries)).to be false }
    end
    describe 'exist' do
      it {
        expect(Summary.exist?('xxx', @summaries)).to be true
        expect(Summary.exist?('xx0', @summaries)).to be true
        expect(Summary.exist?('0xx', @summaries)).to be true
        expect(Summary.exist?('000', @summaries)).to be true
      }
    end
  end
end
