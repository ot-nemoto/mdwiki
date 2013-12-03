class SearchController < ApplicationController

  def search(
    keyword = params[:keyword], 
    chk_title = params[:no_t].nil?, 
    chk_content = params[:no_c].nil?)
    @contents = Content.find(keyword, chk_title, chk_content).sort {|a,b|
      # oreder by update_date desc
      b.update_date <=> a.update_date
    }
    @header_params = HeaderParams.new(HeaderParams::SEARCH, {
      :keyword => keyword,
      :chk_title => chk_title, 
      :chk_content => chk_content})
  end

end
