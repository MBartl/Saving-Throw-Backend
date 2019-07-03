class Api::CampaignsController < ApplicationController

  def index
    if session_user
      @campaigns = DmCampaign.all.select{|join| join.user === session_user}.map{|join| join.campaign}

      @characters = Character.all.select{|character| character.user === session_user}.select{|character| character.campaigns != []}

      @characterCampaigns = @characters.map(&:campaigns).map{|c| c[0]}.uniq if @characters != []

      @response = {campaigns: @campaigns, characterCampaigns: @characterCampaigns}
      render json: @response
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

  private
  def campaign_params
    params.require(:campaign).permit(:name, :description, :pictures, :max_players)
  end
end
