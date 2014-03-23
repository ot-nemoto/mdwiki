# encoding: UTF-8
require 'spec_helper'

describe Attachment do
  describe 'save' do
    before {
      File.open("image_new", "w").close()
    }
    describe 'new' do
      it {
        file = File.new("image_new")
        ufile = ActionDispatch::Http::UploadedFile.new({:tempfile => file, :filename => File.basename(file)})
        Attachment.save('xxx', ufile, ".")
        expect(FileTest.exist?('xxx')).to be true
        expect(FileTest.exist?('xxx/image_new')).to be true
      }
    end
    describe 'already a directory' do
      before {
        FileUtils::mkdir_p 'xxx'
        File.open("xxx/image_1", "w").close()
      }
      it {
        file = File.new("image_new")
        ufile = ActionDispatch::Http::UploadedFile.new({:tempfile => file, :filename => File.basename(file)})
        Attachment.save('xxx', ufile, ".")
        expect(FileTest.exist?('xxx')).to be true
        expect(FileTest.exist?('xxx/image_1')).to be true
        expect(FileTest.exist?('xxx/image_new')).to be true
      }
    end
  end

  describe 'remove_all' do
    before {
      FileUtils::mkdir_p 'xxx'
      File.open("xxx/image_1", "w").close()
      File.open("xxx/image_2", "w").close()
      FileUtils::mkdir_p 'yyy'
      File.open("yyy/image_3", "w").close()
    }
    it {
      Attachment.remove_all('xxx', '.')
      expect(FileTest.exist?('xxx')).to be false
      expect(FileTest.exist?('xxx/image_1')).to be false
      expect(FileTest.exist?('xxx/image_2')).to be false
      expect(FileTest.exist?('yyy')).to be true
      expect(FileTest.exist?('yyy/image_3')).to be true
    }
  end

  describe 'remove' do
    before {
      FileUtils::mkdir_p 'xxx'
      File.open("xxx/image_1", "w").close()
      File.open("xxx/image_2", "w").close()
    }
    it {
      Attachment.remove('xxx', 'image_1', '.')
      expect(FileTest.exist?('xxx')).to be true
      expect(FileTest.exist?('xxx/image_1')).to be false
      expect(FileTest.exist?('xxx/image_2')).to be true
    }
  end

  describe 'find' do
    describe 'not files' do
      before { FileUtils::mkdir_p 'xxx' }
      it { expect(Attachment.find('xxx', '.')).to match_array([]) }
    end
    describe 'in derectory' do
      before { FileUtils::mkdir_p 'xxx/yyy' }
      it { expect(Attachment.find('xxx', '.')).to match_array([]) }
    end
    describe 'file exist' do
      before {
        FileUtils::mkdir_p 'xxx/yyy'
        File.open("xxx/image_1", "w").close()
        File.open("xxx/image_2", "w").close()
      }
      it { expect(Attachment.find('xxx', '.')).to match_array([ 'image_1', 'image_2' ]) }
    end
  end
end
