class Api::CampaignsController < ApplicationController

  def index
    if session_user
      campaigns = Campaign.all.select{|campaign| campaign.user === session_user}
      characterCampaigns = Character.all.select{|character| character.user === session_user}.map(&:campaign)
      response = {campaigns: campaigns, characters: characterCampaigns}
      render json: response
    else
      render json: { errors: 'Please log in first'}
    end
  end

  def create

  end
end
