class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:eidt] #ゲストユーザーが許されるアクション


  def show
    @user = User.find(params[:id])
    # ↑ showのページで、ユーザー１人１人の情報を持ってくる必要があるため、User.find(params[:id])で情報を取得
    @books = @user.books
    @book = Book.new
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    # ↑ 上の２文は、roomがcreateされたときに、現在ログインしているユーザーと、「チャットへ」を押されたユーザー、
    #   両方をEntryテーブルに記録するために、whereメソッドでもう一人、相手のユーザーを探す記述。
    if @user.id == current_user.id  # roomが作成されている場合と、されていない場合に条件分岐を指定した記述
    else
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id then
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      if @is_room
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path, notice: "You have updated user successfully."
    else
      render :edit
    end
  end
  
  def follows
    user = User.find(params[:id])
    @users = user.following_user
  end
  
  def followers
    user = User.find(params[:id])
    @users = user.followers_user
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end
