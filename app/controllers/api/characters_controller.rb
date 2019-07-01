class Api::CharactersController < ApplicationController

  def index
    if session_user
      @characters = Character.all.select{|character| character.user === session_user}

      render json: {characters: @characters}
    end
  end
end
