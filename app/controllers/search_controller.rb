# encoding: UTF-8
class SearchController < ApplicationController

  def search(keywords = StringUtil.trim(params[:keyword]))
    if StringUtil.blank?(keywords)
      @contents = []
    else
      t = Content.arel_table
      query = nil
      union = false
      # subject
      if !params[:subject].nil?
        sub_query = Content.where(t[:deleted].eq(false))
        keywords.split(/\s|　/).each do |keyword|
          sub_query = sub_query.where(t[:subject].matches("%#{keyword}%"))
        end
        if query.nil?
          query = sub_query
        else
          query = query.union(sub_query)
          union = true
        end
      end
      # content
      if !params[:content].nil?
        sub_query = Content.where(t[:deleted].eq(false))
        keywords.split(/\s|　/).each do |keyword|
          sub_query = sub_query.where(t[:content].matches("%#{keyword}%"))
        end
        if query.nil?
          query = sub_query
        else
          query = query.union(sub_query)
          union = true
        end
      end

      if query.nil?
        @contents = []
      else
        query = union ? Content.from("#{query.to_sql} contents").order('updated_at DESC') : query.order('updated_at DESC')
        puts "SQL : #{query.to_sql}"
        @contents = Content.find_by_sql query.to_sql
      end
    end

    @f_permit = FunctionPermission.new(FunctionPermission::SEARCH, {
      :keyword     => keywords,
      :chk_title   => !params[:subject].nil?, 
      :chk_content => !params[:content].nil?})
  end
end
