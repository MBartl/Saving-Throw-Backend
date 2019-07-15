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
      @dm_campaign = DmCampaign.create(user: session_user, campaign: @campaign)
      @chat = Chat.create(campaign: @campaign)
      @response = { campaign: {campaign: @campaign, characters: @campaign.characters}, chat: ChatSerializer.new(@chat) }
      render json: @response, status: :accepted
    else
      handle_campaign_errors
    end
  end

  def update
    params.require(:campaign).permit(:name, :description)

    @campaign = Campaign.find(params[:id])
    if (params[:campaign][:name])
      @campaign.update(name: params[:campaign][:name])
    else
      @campaign.update(description: params[:campaign][:description])
    end

    if @campaign.valid?
      @response = {campaign: {campaign: @campaign, characters: @campaign.characters}}
      render json: @response, status: :accepted
    else
      handle_campaign_errors
    end

  end

  def discover
    @campaigns = []
    Campaign.all.each do |c|
      new = !c.characters.map(&:user).include?(session_user) || !c.dm_campaigns.map(&:user)[0] === session_user
      @campaigns.push({campaign: c, characters: c.characters, dmNeeded: c.dm_campaigns === [] ? true : false}) if new && c.max_players > c.characters.count && c.open_invite === true
    end

    @response = {campaigns: @campaigns}
    render json: @response, status: :accepted
  end

  def join
    params.require(:campaign).permit(:campaign_id, :character_id)

    char_id = params[:campaign][:character_id]

    @cc = CampaignCharacter.create(campaign_id: params[:campaign][:campaign_id], character_id: char_id)

    @campaign = @cc.campaign
    @chat = Chat.all.find{|c| c.campaign === @campaign}

    if @cc.valid?
      render json: {campaign: {campaign: @campaign, characters: @campaign.characters}, chat: {id: @chat.id, campaign: @chat.campaign, characters: @campaign.characters}, character_id: char_id}, status: :accepted
    else
      handle_campaign_errors
    end
  end

  private
  def campaign_params
    params.require(:campaign).permit(:name, :description, :pictures, :max_players)
  end

  def handle_campaign_errors
    @all_errors = ''
    @campaign.errors.full_messages.each do |error|
      if @all_errors === ''
        @all_errors += "#{error}"
      else
        @all_errors += ", #{error}"
      end
    end
    render json: { errors: @all_errors }, status: :not_acceptable
  end
end
