class Api::CharactersController < ApplicationController

  def index
    if session_user
      @characters = Character.all.select{|character| character.user === session_user}

      @response = @characters.map{|c| CharacterSerializer.new(c)}

      render json: {characters: @response}, status: :accepted
    end
  end


  def show
    @character = Character.find(params[:id])

    @response = {character: @character, prof_choices: @character.character_proficiency_choices.count, class_choices: @class_choices}
    render json: @response, status: :accepted
  end


  def create
    # Get and Format Attributes from Params
    @bio = character_params[:biography].gsub(/\n/, '').gsub(/\\/, '').gsub(/"/, '')
    @user = session_user
    @player_class = PlayerClass.find{|pc| pc.name == character_params[:player_class]}
    @race = Race.find{|r| r.name == character_params[:race]}
    @subclass = Subclass.find{|sc| sc.name == character_params[:subclass]}
    @subrace = character_params[:subrace] ? Subrace.find{|sr| sr.name == character_params[:subrace]} : nil

    # Create Character
    @character = Character.new(user: @user, name: character_params[:name], level: character_params[:level], bio: @bio, hit_points: @player_class.hit_die, hp_levels: 1, player_class: @player_class, race: @race, subclass: @subclass, subrace: @subrace)

    # Create Ability Score
    @rawscore = character_params[:ability_score].split(', ')
    @ability_score = create_ascore(@character, @rawscore)

    # Create Character Proficiencies
    create_proficiencies(@player_class, @character)

    # Create Skills
    set_skills(@character, @ability_score)

    # Render character or errors
    if @character.valid?
      @player_choices = @character.character_proficiency_choices
      @class_choices = @character.player_class.class_proficiency_choices

      @response = {character: @character, prof_choices:   @character.character_proficiency_choices.count, class_choices: @class_choices}

      render json: @response, status: :accepted
    else
      @all_errors = ''
      @character.errors.full_messages.each do |error|
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
  def character_params
    params.require(:character).permit(:name, :level, :player_class, :race, :subclass, :subrace, :biography, :ability_score)
  end

  # Create Ability Score
  def create_ascore(character, rawscore)
    return AbilityScore.create(character: character, strength: rawscore[0], dexterity: rawscore[1], constitution: rawscore[2], intelligence: rawscore[3], wisdom: rawscore[4], charisma: rawscore[5])
  end

  # Create Character Proficiencies
  def create_proficiencies(player_class, character)
    player_class.class_proficiencies.each do |class_proficiency|
      CharacterProficiency.create(character: character, proficiency: class_proficiency.proficiency)
    end
  end

  # Create Skills List
  def set_skills(character, ability_score)
    strength, dexterity, intelligence, wisdom, charisma = (ability_score.strength)/2-5, (ability_score.dexterity)/2-5, (ability_score.intelligence)/2-5, (ability_score.wisdom)/2-5, (ability_score.charisma)/2-5

    athletics = strength
    acrobatics, sleight_of_hand, stealth = dexterity, dexterity, dexterity
    arcana, history_s, investigation, nature, religion = intelligence, intelligence, intelligence, intelligence, intelligence
    animal_handling, insight, medicine, perception, survival = wisdom, wisdom, wisdom, wisdom, wisdom
    deception, intimidation, performance, persuasion = charisma, charisma, charisma, charisma

    Skill.create(character: character, athletics: athletics, acrobatics: acrobatics, sleight_of_hand: sleight_of_hand, stealth: stealth, arcana: arcana, history: history_s, investigation: investigation, nature: nature, religion: religion, animal_handling: animal_handling, insight: insight, medicine: medicine, perception: perception, survival: survival, deception: deception, intimidation: intimidation, performance: performance, persuasion: persuasion)
  end
end
