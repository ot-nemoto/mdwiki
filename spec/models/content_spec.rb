require 'spec_helper'

describe Content do
  describe 'save' do
    before {
      @summaries = {
        :test1 => {:title => '4-title', :parent => 'ROOT'},
        :test2 => {:title => '3-title', :parent => 'test1'},
        :test3 => {:title => '2-title', :parent => 'test2'},
        :test4 => {:title => '1-title', :parent => 'test2'}
      }
      @s1 = Summary.new('test5', nil, @summaries)
      Summary.stub(:exist?).and_return(false)
      @c = Content.new('test5', @s1, Pathname('.'))
      @c.parent = 'test1'
    }
    it {
      expect(FileTest.exist?('t/e/test5')).to be false
      @c.save false
      expect(FileTest.exist?('t/e/test5')).to be true
      expect(@summaries[:test1][:parent]).to eq 'ROOT'
      expect(@summaries[:test2][:parent]).to eq 'test1'
      expect(@summaries[:test3][:parent]).to eq 'test2'
      expect(@summaries[:test4][:parent]).to eq 'test2'
      expect(@summaries[:test5][:parent]).to eq 'test1'
    }
  end

  describe 'remove_all' do
    before {
      @summaries = {
        :test1 => {:title => '4-title', :parent => 'ROOT'},
        :test2 => {:title => '3-title', :parent => 'test1'},
        :test3 => {:title => '2-title', :parent => 'test2'},
        :test4 => {:title => '1-title', :parent => 'test2'}
      }
      @s1 = Summary.new('test2', nil, @summaries)
      Summary.stub(:exist?).and_return(false)
      FileUtils.mkdir_p("t/e")
      File.open("t/e/test1", "w").close()
      File.open("t/e/test2", "w").close()
      File.open("t/e/test3", "w").close()
      File.open("t/e/test4", "w").close()
      @c = Content.new('test2', @s1, Pathname('.'))
    }
    it {
      expect(@c.remove_all false).to match_array ['test2', 'test3', 'test4']
      expect(FileTest.exist?('t/e/test1')).to be true
      expect(FileTest.exist?('t/e/test2')).to be false
      expect(FileTest.exist?('t/e/test3')).to be false
      expect(FileTest.exist?('t/e/test4')).to be false
      expect(@summaries[:test1][:parent]).to eq 'ROOT'
      expect(@summaries[:test2]).to be_nil
      expect(@summaries[:test3]).to be_nil
      expect(@summaries[:test4]).to be_nil
    }
  end

  describe 'remove' do
    before {
      @summaries = {
        :test1 => {:title => '4-title', :parent => 'ROOT'},
        :test2 => {:title => '3-title', :parent => 'test1'},
        :test3 => {:title => '2-title', :parent => 'test2'},
        :test4 => {:title => '1-title', :parent => 'test2'}
      }
      @s1 = Summary.new('test2', nil, @summaries)
      Summary.stub(:exist?).and_return(false)
      FileUtils.mkdir_p("t/e")
      File.open("t/e/test1", "w").close()
      File.open("t/e/test2", "w").close()
      File.open("t/e/test3", "w").close()
      File.open("t/e/test4", "w").close()
      @c = Content.new('test2', @s1, Pathname('.'))
    }
    it {
      expect(@c.remove false).to eq 'test2'
      expect(FileTest.exist?('t/e/test1')).to be true
      expect(FileTest.exist?('t/e/test2')).to be false
      expect(FileTest.exist?('t/e/test3')).to be true
      expect(FileTest.exist?('t/e/test4')).to be true
      expect(@summaries[:test1][:parent]).to eq 'ROOT'
      expect(@summaries[:test2]).to be_nil
      expect(@summaries[:test3][:parent]).to eq 'test1'
      expect(@summaries[:test4][:parent]).to eq 'test1'
    }
  end

  describe 'exist_on_title?' do
    before {
      @c = Content.new('dummy')
      @c.stub(:title).and_return('ABC')
      @c.stub(:content).and_return('XYZ')
    }
    it {
      expect(@c.exist_on_title?('B')).to be true
      expect(@c.exist_on_title?('Y')).to be false
    }
  end

  describe 'exist_on_content?' do
    before {
      @c = Content.new('dummy')
      @c.stub(:title).and_return('ABC')
      @c.stub(:content).and_return('XYZ')
    }
    it {
      expect(@c.exist_on_content?('B')).to be false
      expect(@c.exist_on_content?('Y')).to be true
    }
  end

  describe 'find?' do
    describe 'find both' do
      before {
        @c = Content.new('dummy')
        @c.stub(:exist_on_title?).and_return(true)
        @c.stub(:exist_on_content?).and_return(true)
      }
      describe 'target both' do
        it { expect(@c.find?('xxx', true, true)).to be true }
      end
      describe 'target title' do
        it { expect(@c.find?('xxx', true, false)).to be true }
      end
      describe 'target content' do
        it { expect(@c.find?('xxx', false, true)).to be true }
      end
      describe 'none target' do
        it { expect(@c.find?('xxx', false, false)).to be false }
      end
    end
    describe 'find title only' do
      before {
        @c = Content.new('dummy')
        @c.stub(:exist_on_title?).and_return(true)
        @c.stub(:exist_on_content?).and_return(false)
      }
      describe 'target both' do
        it { expect(@c.find?('xxx', true, true)).to be true }
      end
      describe 'target title' do
        it { expect(@c.find?('xxx', true, false)).to be true }
      end
      describe 'target content' do
        it { expect(@c.find?('xxx', false, true)).to be false }
      end
      describe 'none target' do
        it { expect(@c.find?('xxx', false, false)).to be false }
      end
    end
    describe 'find content only' do
      before {
        @c = Content.new('dummy')
        @c.stub(:exist_on_title?).and_return(false)
        @c.stub(:exist_on_content?).and_return(true)
      }
      describe 'target both' do
        it { expect(@c.find?('xxx', true, true)).to be true }
      end
      describe 'target title' do
        it { expect(@c.find?('xxx', true, false)).to be false }
      end
      describe 'target content' do
        it { expect(@c.find?('xxx', false, true)).to be true }
      end
      describe 'none target' do
        it { expect(@c.find?('xxx', false, false)).to be false }
      end
    end
    describe 'not find' do
      before {
        @c = Content.new('dummy')
        @c.stub(:exist_on_title?).and_return(false)
        @c.stub(:exist_on_content?).and_return(false)
      }
      describe 'target both' do
        it { expect(@c.find?('xxx', true, true)).to be false }
      end
      describe 'target title' do
        it { expect(@c.find?('xxx', true, false)).to be false }
      end
      describe 'target content' do
        it { expect(@c.find?('xxx', false, true)).to be false }
      end
      describe 'none target' do
        it { expect(@c.find?('xxx', false, false)).to be false }
      end
    end
  end

  describe 'find' do
    before {
      Summary.stub(:ids).and_return(['test1', 'test2', 'test3'])
      Summary.stub(:exist?).and_return(true)
      FileUtils.mkdir_p("t/e")
      File.open("t/e/test1", "w") {|f| f.write 'ABC'}
      File.open("t/e/test2", "w") {|f| f.write 'XYZ'}
      File.open("t/e/test3", "w") {|f| f.write 'ABC'}
    }
    describe 'hits only one' do
      it {
        actual = Content.find('Y', true, true, Pathname('.'))
        expect(actual.size).to eq 1
        expect(actual[0].id).to eq 'test2'
      }
    end
    describe 'more than one hit' do
      it {
        actual = Content.find('B', true, true, Pathname('.'))
        expect(actual.size).to eq 2
        expect(actual[0].id).to eq 'test1'
        expect(actual[1].id).to eq 'test3'
      }
    end
    describe 'not hit' do
      it { expect(Content.find('H', true, true, Pathname('.')).size).to eq 0 }
    end
  end
end
