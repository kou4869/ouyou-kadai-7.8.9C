class BooksController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @booknew = Book.new
    @book_comment = BookComment.new
    impressionist(@book, nil, :unique => [:ip_address])
    #@tags = Book.tag_counts_on(:tags)
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort_by {|x|
        x.favorited_users.includes(:favorites).where(created_at: from...to).size
      }.reverse
    @book = Book.new
    #@tags = Book.tag_counts_on(:tags)
    
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:raty_count]
      @books = Book.raty_count
    else
      @books = Book.all
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def tag_search
    @books = Book.all
    @tags = Book.tag_counts_on(:tags).order('count DESC')     # 全タグ(Postモデルからtagsカラムを降順で取得)
    if @tag = params[:tag]   # タグ検索用
      @books = Book.tagged_with(params[:tag])
    end
  end


  private

  def book_params
    params.require(:book).permit(:title, :body, :star, :tag_list)
    #tag_list を追加
  end



  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end

end
