class Api::CampaignsController < ApplicationController

  def index
    if session_user
      campaigns = Campaign.all.select{|campaign| campaign.users === session_user}[0]
      characterCampaigns = Character.all.select{|character| character.user === session_user}.map(&:campaigns)[0].map{|campaign| campaign}[0]
      response = {campaigns: campaigns, characters: characterCampaigns}
      render json: response
    end
  end

  def create

  end
end
