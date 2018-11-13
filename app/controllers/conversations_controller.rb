class ConversationsController < ApplicationController
    def index
        @conversations = current_user.mailbox.conversations
    end
    
    def inbox
        @conversations = current_user.mailbox.inbox
        render action: :index
    end
    
    def sent
        @conversations = current_user.mailbox.sentbox
        render action: :index
    end
    
    def trash
        @conversations = current_user.mailbox.trash
        render action: :index
    end    
    
    def show
        @conversation = current_user.mailbox.conversations.find(params[:id])
        @conversation.mark_as_read(current_user)
    end
   
    def new
        @user = User.find_by(id: params[:user])
        @recipients = User.all - [current_user]
    end
    
    def create
        recipient = User.find_by(id: params[:recipient_id])
        receipt = current_user.send_message(recipient, params[:body], params[:subject])
        redirect_to conversation_path(receipt.conversation)
    end
end