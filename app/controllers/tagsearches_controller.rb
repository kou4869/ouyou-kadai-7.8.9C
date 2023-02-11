class TagsearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @word = params[:content]
    @books = Book.where("tag LIKE?","%#{@word}%")
  end
end
