class MessagesChannel < ApplicationCable::Channel
  def subscribed
    chat = Chat.find(params[:chat])
    stream_for chat
  end

  def unsubscribed
    raise "wat"
  end
end
