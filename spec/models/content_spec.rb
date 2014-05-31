require 'spec_helper'

describe Content do
  fixtures :contents
  # content_id
  # 001
  #  |- 002
  #  |   |- 004
  #  |   |- 005
  #  |   |- 006
  #  |   |   |- 007
  #  |   |   |   `- 008
  #  |   |   `- 010
  #  |   `- 009:deleted
  #  `- 003

  describe 'md_to_html' do
    before { @content = Content.find_by content_id: 'C001' }
    it { expect(@content.md_to_html).to eq "<p>content-001</p>\n" }
  end

  describe 'breadcrumb_list' do
    describe 'target is children' do
      before { @content = Content.find_by content_id: 'C007' }
      it {
        actual = @content.breadcrumb_list
        expect(actual.size).to eq 3
        expect(actual[0].content_id).to eq 'C006'
        expect(actual[1].content_id).to eq 'C002'
        expect(actual[2].content_id).to eq 'C001'
      }
    end
    describe 'target is ROOT' do
      before { @content = Content.find_by content_id: 'C001' }
      it {
        actual = @content.breadcrumb_list
        expect(actual.size).to eq 0
      }
    end
  end

  describe 'children' do
    describe 'has children' do
      # subject
      # C004 : zzzz-004
      # C005 : xxxx-005
      # C006 : yyyy-006
      before { @content = Content.find_by content_id: 'C002' }
      it {
        actual = @content.children
        expect(actual.size).to eq 3
        expect(actual[0].content_id).to eq 'C005'
        expect(actual[1].content_id).to eq 'C006'
        expect(actual[2].content_id).to eq 'C004'
      }
    end
    describe 'not children' do
      before { @content = Content.find_by content_id: 'C003' }
      it {
        actual = @content.children
        expect(actual.size).to eq 0
      }
    end
  end

  describe 'children?' do
    describe 'has children' do
      before { @content = Content.find_by content_id: 'C002' }
      it { expect(@content.children?).to be true }
    end
    describe 'not children' do
      before { @content = Content.find_by content_id: 'C003' }
      it { expect(@content.children?).to be false }
    end
  end

  describe 'insert' do
    describe 'registrable' do
      before {
        @content = Content.new
        @content.content_id  = 'C999'
        @content.parent_id   = 'ROOT'
        @content.subject     = 'subject_xxx'
        @content.content     = 'content_xxx'
      }
      it {
        @content.insert 'test_user', Time.utc(2014, 4, 11, 1, 1, 1)
        actual = Content.find_by content_id: 'C999'
        expect(actual.content_id).to eq 'C999'
        expect(actual.parent_id).to eq 'ROOT'
        expect(actual.subject).to eq 'subject_xxx'
        expect(actual.content).to eq 'content_xxx'
        expect(actual.created_user).to eq 'test_user'
        expect(actual.created_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
        expect(actual.updated_user).to eq 'test_user'
        expect(actual.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
        expect(actual.deleted).to be false
      }
    end
    describe 'ActiveRecord::RecordNotUnique' do
      before { @content = Content.find_by content_id: 'C001' }
      it { expect { @content.insert 'test_user', Time.utc(2014, 4, 11, 1, 1, 1) }.to raise_error ActiveRecord::RecordNotUnique }
    end
  end

  describe 'update' do
    describe 'registrable' do
      before {
        @content = Content.find_by content_id: 'C001'
        @content.subject = 'subject_xxx'
        @content.content = 'content_xxx'
      }
      it {
        @content.update 'test_user', Time.utc(2014, 4, 11, 1, 1, 1)
        actual = Content.find_by content_id: 'C001'
        expect(actual.content_id).to eq 'C001'
        expect(actual.parent_id).to eq 'ROOT'
        expect(actual.subject).to eq 'subject_xxx'
        expect(actual.content).to eq 'content_xxx'
        expect(actual.created_user).to eq 'nemonium1'
        expect(actual.created_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-10 00:00:00'
        expect(actual.updated_user).to eq 'test_user'
        expect(actual.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
        expect(actual.deleted).to be false
      }
    end
  end

  describe 'remove' do
    describe 'registrable' do
      before { @content = Content.find_by content_id: 'C006' }
      it {
        removed_content_id = @content.remove 'test_user', Time.utc(2014, 4, 11, 1, 1, 1)
        expect(removed_content_id).to eq 'C006'

        actual = Content.find_by content_id: 'C006'
        expect(actual.content_id).to eq 'C006'
        expect(actual.parent_id).to eq 'C002'
        expect(actual.subject).to eq 'yyyy-006'
        expect(actual.content).to eq 'content-006'
        expect(actual.created_user).to eq 'nemonium1'
        expect(actual.created_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-10 00:00:00'
        expect(actual.updated_user).to eq 'test_user'
        expect(actual.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
        expect(actual.deleted).to be true

        # Parent of a children changes
        c1 = Content.find_by content_id: 'C007'
        expect(c1.parent_id).to eq 'C002'
        expect(c1.updated_user).to eq 'nemonium2'
        expect(c1.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 12:12:12'
        c2 = Content.find_by content_id: 'C010'
        expect(c2.parent_id).to eq 'C002'
        expect(c2.updated_user).to eq 'nemonium2'
        expect(c2.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 12:12:12'
      }
    end
  end

  describe 'remove_all' do
    describe 'registrable' do
      before { @content = Content.find_by content_id: 'C006' }
      it {
        removed_content_ids = @content.remove_all 'test_user', Time.utc(2014, 4, 11, 1, 1, 1)
        expect(removed_content_ids).to match_array ['C006', 'C007', 'C008', 'C010']

        actual = Content.find_by content_id: 'C006'
        expect(actual.content_id).to eq 'C006'
        expect(actual.parent_id).to eq 'C002'
        expect(actual.subject).to eq 'yyyy-006'
        expect(actual.content).to eq 'content-006'
        expect(actual.created_user).to eq 'nemonium1'
        expect(actual.created_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-10 00:00:00'
        expect(actual.updated_user).to eq 'test_user'
        expect(actual.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
        expect(actual.deleted).to be true

        # deleted children
        c1 = Content.find_by content_id: 'C007'
        expect(c1.updated_user).to eq 'test_user'
        expect(c1.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
        expect(c1.deleted).to be true
        c2 = Content.find_by content_id: 'C008'
        expect(c2.updated_user).to eq 'test_user'
        expect(c2.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
        expect(c2.deleted).to be true
        c3 = Content.find_by content_id: 'C010'
        expect(c3.updated_user).to eq 'test_user'
        expect(c3.updated_at.strftime("%Y-%m-%d %H:%M:%S")).to eq '2014-04-11 01:01:01'
        expect(c3.deleted).to be true
      }
    end
  end

end
