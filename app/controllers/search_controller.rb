class SearchController < ApplicationController

  def search(keyword = params[:keyword])
    @contents = Content.find(keyword).sort {|a,b|
      # oreder by update_date desc
      b.update_date <=> a.update_date
    }
    @header_params = HeaderParams.new(HeaderParams::SEARCH, keyword)
  end

end
