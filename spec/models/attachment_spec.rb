require 'spec_helper'

describe Attachment do

  describe 'upload' do
    describe 'registrable - insert' do
      before {
        File.open("upload_content", "w").close()
        file = File.new("upload_content")
        @uploaded_file = ActionDispatch::Http::UploadedFile.new({
          :tempfile => file,
          :type => 'text/plain',
          :filename => File.basename(file)})
      }
      it {
        attach = Attachment.new
        attach.content_id   = 'C001'
        attach.filename     = @uploaded_file.original_filename
        attach.attachment   = @uploaded_file.read
        attach.content_type = @uploaded_file.content_type
        attach.upload 'test_user', Time.utc(2014, 4, 11, 1, 1, 1)

        actual = Attachment.find_by content_id: 'C001', filename: @uploaded_file.original_filename
        expect(actual.attachment_id.empty?).to be false
        expect(actual.content_id).to eq 'C001'
        expect(actual.filename).to eq 'upload_content'
        expect(actual.content_type).to eq 'text/plain'
        expect(actual.updated_user).to eq 'test_user'
        expect(actual.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
        expect(actual.deleted).to eq false
      }
    end

    describe 'registrable - update' do
      describe 'not deleted' do
        before {
          File.open("upload_content", "w").close()
          file = File.new("upload_content")
          @uploaded_file = ActionDispatch::Http::UploadedFile.new({
            :tempfile => file,
            :type => 'text/plain',
            :filename => File.basename(file)})
          Attachment.create(
            attachment_id: 'A001',
            content_id: 'C001',
            filename: @uploaded_file.original_filename,
            attachment: @uploaded_file.read,
            content_type: @uploaded_file.content_type,
            updated_user: 'nemonium1',
            updated_at: Time.utc(2013, 12, 31, 2, 2, 2))
        }
        it {
          attach = Attachment.new
          attach.content_id    = 'C001'
          attach.filename      = @uploaded_file.original_filename
          attach.attachment    = @uploaded_file.read
          attach.content_type  = @uploaded_file.content_type
          attach.upload 'test_user', Time.utc(2014, 4, 11, 1, 1, 1)
  
          actual = Attachment.find_by content_id: 'C001', filename: @uploaded_file.original_filename
          expect(actual.attachment_id).to eq 'A001'
          expect(actual.content_id).to eq 'C001'
          expect(actual.filename).to eq 'upload_content'
          expect(actual.content_type).to eq 'text/plain'
          expect(actual.updated_user).to eq 'test_user'
          expect(actual.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
          expect(actual.deleted).to eq false
        }
      end

      # Again, if content_id and filename are equal, attachment_id is the same.
      describe 'deleted' do
        before {
          File.open("upload_content", "w").close()
          file = File.new("upload_content")
          @uploaded_file = ActionDispatch::Http::UploadedFile.new({
            :tempfile => file,
            :type => 'text/plain',
            :filename => File.basename(file)})
          Attachment.create(
            attachment_id: 'A001',
            content_id: 'C001',
            filename: @uploaded_file.original_filename,
            attachment: @uploaded_file.read,
            content_type: @uploaded_file.content_type,
            updated_user: 'nemonium1',
            updated_at: Time.utc(2013, 12, 31, 2, 2, 2),
            deleted: true)
        }
        it {
          attach = Attachment.new
          attach.content_id    = 'C001'
          attach.filename      = @uploaded_file.original_filename
          attach.attachment    = @uploaded_file.read
          attach.content_type  = @uploaded_file.content_type
          attach.upload 'test_user', Time.utc(2014, 4, 11, 1, 1, 1)
  
          actual = Attachment.find_by content_id: 'C001', filename: @uploaded_file.original_filename
          expect(actual.attachment_id).to eq 'A001'
          expect(actual.content_id).to eq 'C001'
          expect(actual.filename).to eq 'upload_content'
          expect(actual.content_type).to eq 'text/plain'
          expect(actual.updated_user).to eq 'test_user'
          expect(actual.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
          expect(actual.deleted).to eq false
        }
      end
    end
  end

  describe 'remove' do
    before {
      File.open("upload_content", "w").close()
      file = File.new("upload_content")
      @uploaded_file = ActionDispatch::Http::UploadedFile.new({
        :tempfile => file,
        :type => 'text/plain',
        :filename => File.basename(file)})
      Attachment.create(
        attachment_id: 'A001',
        content_id: 'C001',
        filename: @uploaded_file.original_filename,
        attachment: @uploaded_file.read,
        content_type: @uploaded_file.content_type,
        updated_user: 'nemonium1',
        updated_at: Time.utc(2013, 12, 31, 2, 2, 2))
    }
    it {
      attach = Attachment.new
      attach.attachment_id = 'A001'
      attach.remove 'test_user', Time.utc(2014, 4, 11, 1, 1, 1)

      actual = Attachment.find_by content_id: 'C001', filename: @uploaded_file.original_filename
      expect(actual.attachment_id).to eq 'A001'
      expect(actual.content_id).to eq 'C001'
      expect(actual.filename).to eq 'upload_content'
      expect(actual.content_type).to eq 'text/plain'
      expect(actual.updated_user).to eq 'test_user'
      expect(actual.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
      expect(actual.deleted).to eq true
    }
  end

  describe 'remove_by_content_id' do
    before {
      Attachment.create(attachment_id: 'A001', content_id: 'C001', filename: 'test1')
      Attachment.create(attachment_id: 'A002', content_id: 'C001', filename: 'test2')
      Attachment.create(attachment_id: 'A003', content_id: 'C002', filename: 'test3')
    }
    it {
      Attachment.remove_by_content_id 'C001', 'test_user', Time.utc(2014, 4, 11, 1, 1, 1)
      
      atchs = Attachment.where content_id: 'C001'
      atchs.each do |atch|
        expect(atch.deleted).to be_true
      end
      atchs = Attachment.where content_id: 'C002'
      atchs.each do |atch|
        expect(atch.deleted).to be_false
      end
    }
  end
end
