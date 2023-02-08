class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.create(user_id: current_user.id)
    @information1 = Information.create(room_id: @room.id, user_id: current_user.id)
    @information2 = Information.create(params.require(:information).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    @room = Room.find(params[:id])

    if Information.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @some_information = @room.some_information
      #Roomで相手の名前表示するために使う
      @my_user_id = current_user.id
    else
      redirect_back(fallback_location: root_path)
    end
  end

end
