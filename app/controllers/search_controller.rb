class SearchController < ApplicationController
  skip_after_action :verify_authorized

  def find
    @search = search_params.empty? ? Search.new : Search.find(search_params)
  end

  private

  def search_params
    params[:search] ? params.require(:search).permit(:q, indices: []) : {}
  end
end
