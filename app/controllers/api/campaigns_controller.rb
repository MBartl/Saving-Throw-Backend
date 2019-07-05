class Api::CampaignsController < ApplicationController

  def index
    if session_user
      @campaigns = []
      @characters = []

      Campaign.all.each do |c|
        dm = c.dm_campaigns.first
        users = c.characters.map(&:user)
        @campaigns.push({campaign: c, characters: c.characters}) if dm && dm.user === session_user
        @characters.push({campaign: c, characters: c.characters}) if users.include?(session_user)
      end

      @response = {campaigns: @campaigns, characterCampaigns: @characters}
      render json: @response, status: :accepted
    end
  end

  def create
    @campaign = Campaign.create(campaign_params)

    if @campaign.valid?
      render json: @campaign, status: :accepted
    else
      @all_errors = ''
      @user.errors.full_messages.each do |error|
        if @all_errors === ''
          @all_errors += "#{error}"
        else
          @all_errors += ", #{error}"
        end
      end
      render json: { errors: @all_errors }, status: :not_acceptable
    end
  end

  def discover
    @campaigns = []
    Campaign.all.each do |c|
      new = !c.characters.map(&:user).include?(session_user)
      @campaigns.push({campaign: c, characters: c.characters, dmNeeded: c.dm_campaigns === [] ? true : false}) if new
    end

    @response = { campaigns: @campaigns }
    render json: @response, status: :accepted
  end

  private
  def campaign_params
    params.require(:campaign).permit(:name, :description, :pictures, :max_players)
  end
end
