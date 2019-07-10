class Api::ChatsController < ApplicationController
  def index
    @chats = Chat.all.select{|c| c.campaign.characters.map(&:user).include?(session_user) || c.campaign.dm_campaigns.map(&:user).include?(session_user)}

    render json: @chats
  end

  def create
    @chat = Chat.new(chat_params)
    if @chat.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        ChatSerializer.new(@chat)
      ).serializable_hash
      ActionCable.server.broadcast 'chats_channel', serialized_data
      head :ok
    end
  end


  private

  def chat_params
    params.require(:chat).permit(:title, :campaign)
  end
end
