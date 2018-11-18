class FriendshipsController < ApplicationController
	
  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:notice] = "Friend request sent!"
      redirect_to :back
    else
      errors.add(:friendships, "Unable to send friend request.")
      redirect_to :back
    end
  end

  def update
    @friendship = Friendship.where(friend_id: [current_user, params[:id]], user_id: [current_user, params[:id]]).first
    @friendship.update(accepted: true)
    if @friendship.save
      redirect_to :back, notice: "Friend request accepted."
    else
      redirect_to :back, notice: "Unable to accept friend request."
    end
  end

  def destroy
    @friendship = Friendship.where(friend_id: [current_user, params[:id]]).where(user_id: [current_user, params[:id]]).last
    @friendship.destroy
    flash[:notice] = "Friend request declined."
    redirect_to :back
  end
  
  def index
  	
  end

end