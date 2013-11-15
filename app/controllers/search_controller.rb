class SearchController < ApplicationController

  def search(keyword = params[:keyword])
    @header_params = HeaderParams.new(HeaderParams::SEARCH, keyword)
  end

end
