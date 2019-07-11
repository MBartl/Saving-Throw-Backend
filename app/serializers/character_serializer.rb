class CharacterSerializer < ActiveModel::Serializer
  attributes :id, :name, :bio, :level, :hit_points, :player_class, :race, :subclass, :subrace, :character_proficiency_choices, :character_proficiencies, :campaign, :choices_remaining, :spellcasting

  belongs_to :user
  belongs_to :player_class
  belongs_to :race
  belongs_to :subclass
  belongs_to :subrace
  has_many :campaign_characters

  has_many :character_proficiency_choices
  has_many :character_proficiencies

  def player_class
    self.object.player_class do |player_class|
      {
        id: player_class.id,
        name: player_class.name,
        class_spells: player_class.class_spells
      }
    end
  end

  def race
    self.object.race do |race|
      {
        id: race.id,
        name: race.name
      }
    end
  end

  def subclass
    self.object.subclass do |subclass|
      {
        id: subclass.id,
        name: subclass.name,
        class_spells: subclass.class_spells
      }
    end
  end

  def subrace
    self.object.subrace do |subrace|
      {
        id: subrace.id,
        name: subrace.name
      }
    end
  end

  def campaign
    self.object.campaigns do |campaign|
      {
        id: campaign.id,
        name: campaign.name
      }
    end
  end

  def choices_remaining
    self.object do |character|
      (character.player_class.class_proficiency_choices[1].choices-character.character_proficiency_choices.count)
    end
  end

  def spellcasting
    self.object.player_class do |pc|
      {
        spellcasting: pc.spellcasting
      }
    end
  end
end
