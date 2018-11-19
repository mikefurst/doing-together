class ForumPostController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    
    def list
        if current_user.groupid == nil
            redirect_to '/'
            return
        end
        @group = Group.find(current_user.groupid)
        @forum_posts = ForumPost.select {|fp|
            fp.groupID == @group.id
        }
        @forum_posts.each {|fp|
            fp.calculateRating
        }
    end
    def forum_posts_param
        params.require(:forum_post).permit(:title,:message)
    end
    def create
        @title = forum_posts_param[:title]
        @message = forum_posts_param[:message]
        @rating = 0
        @creatorID = current_user.id
        @groupID = current_user.groupid
        if @title == nil or @message == nil or @creatorID == nil or @groupID == nil
            flash[:alert] = 'Invalid Content'
            redirect_to :action => 'list', :controller => 'forum_post'
            return
        elsif @title.length < 10 or @title.length > 50
            flash[:alert] = 'Title is invalid length.'
            redirect_to :action => 'list', :controller => 'forum_post'
            return
        elsif @message.length < 10
            flash[:alert] = 'Message is invalid length.'
            redirect_to :action => 'list', :controller => 'forum_post'
            return
        end
        @fp = ForumPost.create(:title => @title, :message => @message, :rating => @rating, :creatorID => @creatorID, :groupID => @groupID)
        if @fp.save
            redirect_to :action => 'list', :controller => 'forum_post'
        else
            flash[:alert] = 'Error Creating Forum Post'
            redirect_to :action => 'list', :controller => 'forum_post'
        end
    end
    
    def vote
        if params[:postID]==nil or params[:thumbsUp]==nil
            render :status => '200', :text => 'FAILURE'
            return
        elsif ForumPost.find(params[:postID])==nil
            render :status => '200', :text => 'FAILURE'
            return
        end
        @votes = Vote.select {|v|
            v.postID == params[:postID] and v.creatorID == current_user.id 
        }
        if @votes.blank?
            @vote = Vote.create(:creatorID => current_user.id, :postID => params[:postID], :thumbsUp => params[:thumbsUp])
            if @vote.save
                render :status => '200', :text => 'SUCCESS_N'
            else
                render :status => '200', :text => 'FAILURE'
            end
        else
            @vote = @votes.first
            @check = @vote.thumbsUp == params[:thumbsUp]
            @vote.thumbsUp = params[:thumbsUp]
            if @vote.save
                if @check
                    render :status => '200', :text => 'SUCCESS_S'
                else
                    render :status => '200', :text => 'SUCCESS_E'
                end
            else
                render :status => '200', :text => 'FAILURE'
            end
        end
    end
end
