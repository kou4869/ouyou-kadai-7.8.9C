class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @word = params[:word]
    @search = params[:method]
    if @model == "user"
      @records = User.search_for(@word, @method)
    else
      @records = Book.search_for(@word, @method)
    end
  end
  
end
