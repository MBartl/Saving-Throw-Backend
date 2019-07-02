# This seed file makes a bunch of calls to this D&D API:
# http://www.dnd5eapi.co/
#
# Current call count: 941 (1197 w/ equipment)
#
# Please allow up to 10 minutes for the seed file to run


# Create Sample Users
User.destroy_all
User.reset_pk_sequence

z = 1
12.times do
  User.create(username:"test#{z}", name: Faker::Name.first_name + " " + Faker::Name.last_name, email:Faker::Internet.email, bio:Faker::Hipster.sentence(4, false, 4), age:rand(33)+17, location:"#{Faker::Address.city}, #{Faker::Address.state_abbr}", password:"test")
  z += 1
end


# Seed followers/following
Following.destroy_all
Following.reset_pk_sequence
37.times do
  user1 = User.all.sample
  user2 = User.all.sample
  unless user1 == user2
    Following.create(follower: user1, following: user2)
  end
end


# Delete and reset all seeded classes

# CharacterEquipment.destroy_all
# WeaponProperty.destroy_all
# Equipment.destroy_all
# CharacterSpell.destroy_all

Feature.destroy_all
Spellcasting.destroy_all
RaceTrait.destroy_all
ClassProficiencyChoice.destroy_all
ClassProficiency.destroy_all
RaceProficiency.destroy_all
ClassSpell.destroy_all
Proficiency.destroy_all
Spell.destroy_all
Trait.destroy_all
Subrace.destroy_all
Race.destroy_all
Subclass.destroy_all
PlayerClass.destroy_all
DmCampaign.destroy_all
Campaign.destroy_all


# CharacterEquipment.reset_pk_sequence
# WeaponProperty.reset_pk_sequence
# Equipment.reset_pk_sequence
# CharacterSpell.reset_pk_sequence

Feature.reset_pk_sequence
Spellcasting.reset_pk_sequence
RaceTrait.reset_pk_sequence
ClassProficiencyChoice.reset_pk_sequence
ClassProficiency.reset_pk_sequence
RaceProficiency.reset_pk_sequence
ClassSpell.reset_pk_sequence
Proficiency.reset_pk_sequence
Spell.reset_pk_sequence
Trait.reset_pk_sequence
Subrace.reset_pk_sequence
Race.reset_pk_sequence
Subclass.reset_pk_sequence
PlayerClass.reset_pk_sequence
DmCampaign.reset_pk_sequence
Campaign.reset_pk_sequence


# Define base URL
url = "http://www.dnd5eapi.co/api/"

# Seed Classes
i = 0
12.times do
  i += 1
  data = JSON.parse(RestClient.get(url + "classes/#{i}"))
  PlayerClass.create(name: data['name'], hit_die: data['hit_die'], saving_throws: data['saving_throws'].map {|x| x['name']}.join(', '), proficiency_choices: data['proficiency_choices'][0]['choose'])
end

# Seed Subclasses
j = 0
12.times do
  j += 1
  data = JSON.parse(RestClient.get(url + "subclasses/#{j}"))
  Subclass.create!(name: data['name'], player_class: PlayerClass.find {|x| x.name == data['class']['name']}, flavor: data['subclass_flavor'], desc: data['desc'][0])
end

# Seed Proficiencies and ClassProficiencies
l = 0
122.times do
  l += 1
  data = JSON.parse(RestClient.get(url + "proficiencies/#{l}"))
  proficiency = Proficiency.create(category: data['type'], name: data['name'])
  data['classes'].each do |player_class|
    ClassProficiency.create(player_class: PlayerClass.find {|x| x.name == player_class['name']}, proficiency: proficiency)
  end
end

# Seed Races
k = 0
9.times do
  k += 1
  data = JSON.parse(RestClient.get(url + "races/#{k}"))
  race = Race.create!(name: data['name'], speed: data['speed'], ability_bonuses: data['ability_bonuses'], alignment: data['alignment'], age: data['age'], size: data['size'])

  if data['starting_proficiencies']
    data['starting_proficiencies'].each do |proficiency|
      dbProficiency = Proficiency.find {|x| x.name == proficiency['name']} ? nil :
        RaceProficiency.create(race: race, proficiency: dbProficiency)
    end
  end
end

# Seed ClassChoices
i = 0
12.times do
  i += 1
  data = JSON.parse(RestClient.get(url + "classes/#{i}"))
  player_class = PlayerClass.find{|p_class| p_class.name == data['name']}
  data['proficiency_choices'][0]['from'].each do |choice|
    proficiency_choice = Proficiency.find{|prof| prof.name == choice['name']}
    ClassProficiencyChoice.create(player_class: player_class, proficiency: proficiency_choice, choices: data['proficiency_choices'][0]['choose'])
  end
end

# Seed Traits and Race-Trait join table
m = 0
27.times do
  m += 1
  data = JSON.parse(RestClient.get(url + "traits/#{m}"))
  trait = Trait.create(name: data['name'], desc: data['desc'][0])

  data['races'].each do |race|
    name = race['name'].split(' ').last
    race = Race.find {|x| x.name == name}
    RaceTrait.find {|x| x.race == race && x.trait == trait} ? nil :
      RaceTrait.create(race: race, trait: trait)
  end
end

r = 0
6.times do
  r += 1
  data = JSON.parse(RestClient.get(url + "subraces/#{r}"))
  subrace = Subrace.create(name: data['name'], race: Race.find {|x| x.name == data['race']['name']}, desc: data['desc'], ability_bonuses: data['ability_bonuses'])

  if data['starting_proficiencies:']
    data['starting_proficiencies:'].each do |proficiency|
      dbProficiency = Proficiency.find {|x| x.name == proficiency['name']} ? nil :
        RaceProficiency.create(subrace: subrace, proficiency: dbProficiency)
    end
  end

  if data['racial_traits']
    data['racial_traits'].each do |trait|
      dbTrait = Trait.find {|x| x.name == trait['name']} ? nil :
        RaceTrait.create(subrace: subrace, trait: dbTrait)
    end
  end
end

# Seed Features
s = 0
414.times do
  s += 1
  data = JSON.parse(RestClient.get(url + "features/#{s}"))
  Feature.create(name: data['name'], player_class: PlayerClass.find{|pc| pc.name == data['class']['name']}, level: data['level'], desc: data['desc'].join('<<|>>'))
end

# Spellcasting
q = 0
8.times do
  q += 1
  data = JSON.parse(RestClient.get(url + "spellcasting/#{q}"))

  Spellcasting.create(ability: data['spellcasting_ability']['name'], player_class: PlayerClass.find{|pc| pc.name == data['class']['name']}, level: data['level'], info: data['info'].map{|info| info['name'] + ": " + info['desc'][0]}.join('<<|>>').gsub(/â€™/, "'").gsub(/â€�/, '"').gsub(/â€œ/, '"'))
end

# Seed Spells and Class/Subclass-Spell join table
n = 0
319.times do
  n += 1
  data = JSON.parse(RestClient.get(url + "spells/#{n}"))
  spell = Spell.create(name: data['name'], desc: data['desc'][0], range: data['range'], components: data['components'].join(', '), duration: data['duration'], concentration: data['concentration'] == 'yes' ? true : false, casting_time: data['casting_time'], level: data['level'], school: data['school']['name'])

  data['classes'].each do |player_class|
    ClassSpell.create(player_class: PlayerClass.find {|x| x.name == player_class['name']}, spell: spell)
  end

  data['subclasses'].each do |subclass|
    ClassSpell.create(subclass: Subclass.find {|x| x.name == subclass['name']}, spell: spell)
  end
end


# Create campaigns
c1 = Campaign.create(name: "Princes of the Apocolypse", description: "A terrible threat gathers in the North. Throughout this region of the Forgotten Realms, savage marauders bring destruction. Monsters are on the prowl, preying on flocks, rampaging through croplands, and attacking homesteads and travelers. In settlements, discord and suspicion grow. Sinister strangers lurk in the shadows, whispering about how everything is soon to change.", max_players: rand(6)+6, open_invite: true, closed: false)
c1.update(open_invite: false) if rand(4) == 1

c2 = Campaign.create(name: "Death House", description: "Death House is the name given to an old row house in the village of Barovia (area E7 on the village map). The house has been burned to the ground many times, only to rise from the ashes time and again—by its own will or that of Strahd. Locals give the building a wide berth for fear of antagonizing the evil spirits believed to haunt it.", max_players: rand(6)+6, open_invite: true, closed: false)
c2.update(open_invite: false) if rand(4) == 1

c3 = Campaign.create(name: "Tyranny in Phlan", description: "Things are changing in Phlan, and for the worse. The Cult of the Dragon has spies deeply rooted in the castle and has been corrupting many of the town’s defenders, gathering new allies and otherwise readying to make a move for control of the town and the Pool of Radiance that lies beneath it. Knight Commander Ector Brahms, the Lord Regent of Phlan, has called a secret summit of the masters of the town’s four major guilds and the head of each noble house. At the foot of the Cinnabar Throne, he plans to hammer out the terms of an alliance and bring order and peace to the town once and for all. It is here, however, that the hammer will fall in the form of Vorgansharax, the Maimed Virulence: a green dragon who has allied himself with the Cult of the Dragon in exchange for dominion over Phlan.", max_players: rand(6)+6, open_invite: true, closed: false)
c3.update(open_invite: false) if rand(4) == 1

c4 = Campaign.create(name: "A Wild Sheep Chase", description: "The party’s attempt to grab a rare afternoon of downtime is interrupted by a frantic sheep equipped with a Scroll of Speak to Animals and a fierce determination to get their attention. With the aid of some magic, the creature reveals itself to be no mere beast, but a wizard who fell victim to an embittered apprentice and a stolen Wand of True Polymorph.
After two years imprisoned with nothing to eat but his own lawn, the ex-elf has escaped and is in dire need of aid. Transformed assassins are looking to grab themselves a mutton dinner, while the only object capable of restoring his opposable thumbs lies in the hands of his former pupil and current nemesis. Fortunately, the wooly wizard has found new allies he can rely on, right?", max_players: rand(6)+6, open_invite: true, closed: false)
c4.update(open_invite: false) if rand(4) == 1

c5 = Campaign.create(name: "The Wolves of Welton", description: "It’s been a long time since the people of Welton have worried about anything more frightening than sheep ticks or a late frost, but now a pack of strangely determined wolves is driving farmers from their fields and spiriting away entire flocks in the middle of the night.
With food supplies running low and their sorcerer-in-residence nowhere to be found, the village council sends out a desperate plea for brave adventurers to destroy the beasts for good. Is the job as easy as a walk in the woods, or is there more to the Wolves of Welton than mere animal cunning? There's only one way to find out…", max_players: rand(6)+6, open_invite: true, closed: false)
c5.update(open_invite: false) if rand(4) == 1

c6 = Campaign.create(name: "The Fiery Grog", description: "The Fiery Grog is a popular watering hole for the more rough and tumble folk of Port Myrandu. The seedy tavern is often the meeting place for shady dealings kept hidden by the loud drunken activities that permeate the building each night.
Whether your adventurers are meeting an important NPC in private, they’re in need of a quest hook or two to move the adventure forward, or looking to blow off some steam by partying hard and maybe get into a brawl, the Fiery Grog is the place to go.", max_players: rand(6)+6, open_invite: true, closed: false)
c6.update(open_invite: false) if rand(4) == 1

c7 = Campaign.create(name: "Madness of the Rat King", description: "An ambitious were-rat alchemist known only as 'the Rat King' set up a base of operations down in these caverns a year ago. He has been working tirelessly in his laboratory since then, using alchemy and magic to mutate and breed loyal rat minions to suit his needs: for example, combining rats with aberrant beholder essence to create loyal 'laser rats' with the ability to float and shoot fiery rays, as alchemists are wont to do. To sustain his operations, he sends his rat minions out into the world to collect supplies, from food/drink to other necessary equipment.
The initial motives for the Rat King’s experimentation is a mystery even to himself. At some point during his time in these caverns, a dark influence took hold of him, slowly driving him insane. The Rat King now has one clear goal in his crazed mind: to create an army of mutant rats and take over the surface, to escape and protect the world from what he calls “the Old Voice,” a malicious entity that whispers to him endlessly from the deep.", max_players: rand(6)+6, open_invite: true, closed: false)
c7.update(open_invite: false) if rand(4) == 1

c8 = Campaign.create(name: "Seven Weddings", description: "Lilian was a witch who studied the arcane in a hamlet called Lukestown. Her love of mysticisms was only eclipsed by her love for her fiancé Marcus. Lilian loved him so much, she began crafting a pair of magical rings that would grant her and Marcus immortality. However, the powerful magics involved were well beyond Lilian’s skills. One night while working on the rings, the life and death magics went awry, killing Lilian.
Marcus was crushed. They laid Lilian to rest in the town’s mausoleum. It was not long before Lilian's spirit rose, fueled by her own foul magics. Marcus tried to visit, but over time, Lilian grew more and more hateful. Marcus stopped visiting when it became clear her undead nature had overpowered any humanity left within.", max_players: rand(6)+6, open_invite: true, closed: false)
c8.update(open_invite: false) if rand(4) == 1

# Create DM's
Campaign.all.each do |campaign|
  if rand(2) > 0
    DmCampaign.create(campaign: campaign, user: User.all.sample)
  end
end




AbilityScore.destroy_all
Skill.destroy_all
CampaignCharacter.destroy_all
CharacterProficiencyChoice.destroy_all
CharacterProficiency.destroy_all
Character.destroy_all

AbilityScore.reset_pk_sequence
Skill.reset_pk_sequence
CampaignCharacter.reset_pk_sequence
CharacterProficiencyChoice.reset_pk_sequence
CharacterProficiency.reset_pk_sequence
Character.reset_pk_sequence



# Create character proficiencies
def create_proficiencies(new, ability_score)
  counter = (new.player_class.proficiency_choices - new.character_proficiency_choices.count)

  counter.times do
    newProf = new.player_class.class_proficiency_choices.sample.proficiency
    if new.character_proficiency_choices.include?(newProf)
      return create_proficiencies(new, ability_score)
    else
      CharacterProficiencyChoice.create(proficiency: newProf, character: new, proficiency_type: newProf.category)
    end
  end
end


# Create skills
def create_skills(new, ability_score)
  # modifiers
  strength, dexterity, intelligence, wisdom, charisma = (ability_score.strength)/2-5, (ability_score.dexterity)/2-5, (ability_score.intelligence)/2-5, (ability_score.wisdom)/2-5, (ability_score.charisma)/2-5

  # create skill based on ability score modifier
  athletics = strength
  acrobatics, sleight_of_hand, stealth = dexterity, dexterity, dexterity
  arcana, history_s, investigation, nature, religion = intelligence, intelligence, intelligence, intelligence, intelligence
  animal_handling, insight, medicine, perception, survival = wisdom, wisdom, wisdom, wisdom, wisdom
  deception, intimidation, performance, persuasion = charisma, charisma, charisma, charisma

  # collect proficiency choices
  skill_bonuses = new.character_proficiency_choices.select{|x| x.proficiency_type == "Skills"}.map(&:proficiency).map(&:name).map{|x| x.split(': ')[1].downcase}
  skill_bonuses.each do |bonus|
    athletics += (new.level/4.floor() + 2) if bonus == "athletics"
    acrobatics += (new.level/4.floor() + 2) if bonus == "acrobatics"
    sleight_of_hand += (new.level/4.floor() + 2) if bonus == "sleight_of_hand"
    stealth += (new.level/4.floor() + 2) if bonus == "stealth"
    arcana += (new.level/4.floor() + 2) if bonus == "arcana"
    history_s += (new.level/4.floor() + 2) if bonus == "history_s"
    investigation += (new.level/4.floor() + 2) if bonus == "investigation"
    nature += (new.level/4.floor() + 2) if bonus == "nature"
    religion += (new.level/4.floor() + 2) if bonus == "religion"
    animal_handling += (new.level/4.floor() + 2) if bonus == "animal_handling"
    insight += (new.level/4.floor() + 2) if bonus == "insight"
    medicine += (new.level/4.floor() + 2) if bonus == "medicine"
    perception += (new.level/4.floor() + 2) if bonus == "perception"
    survival += (new.level/4.floor() + 2) if bonus == "survival"
    deception += (new.level/4.floor() + 2) if bonus == "deception"
    intimidation += (new.level/4.floor() + 2) if bonus == "intimidation"
    performance += (new.level/4.floor() + 2) if bonus == "performance"
    persuasion += (new.level/4.floor() + 2) if bonus == "persuasion"
    intimidation += 2 if new.race.name == "Half-Orc"
  end

  Skill.create(character: new, athletics: athletics, acrobatics: acrobatics, sleight_of_hand: sleight_of_hand, stealth: stealth, arcana: arcana, history: history_s, investigation: investigation, nature: nature, religion: religion, animal_handling: animal_handling, insight: insight, medicine: medicine, perception: perception, survival: survival, deception: deception, intimidation: intimidation, performance: performance, persuasion: persuasion)
end


# Create characters (1 of 2)
16.times do
  # Create character
  player_class = PlayerClass.all.sample
  player_race = Race.all.sample
  level = rand(12)+3
  user = User.all.sample
  new = Character.create(user: user, name: Faker::Games::WorldOfWarcraft.unique.hero, level: level, bio: Faker::Books::Dune.unique.quote, hit_points: player_class.hit_die, player_class: player_class, race: player_race, subclass: Subclass.select{|x| x.player_class == player_class}.sample, subrace: Subrace.select{|x| x.race == player_race}.sample)

  # Create AbilityScore
  ability_score = AbilityScore.create(character: new, strength: rand(9)+8, dexterity: rand(9)+8, constitution: rand(9)+9, intelligence: rand(9)+8, wisdom: rand(9)+8, charisma: rand(9)+8)

  # Create CharacterProficiency join
  player_class.class_proficiencies.each do |class_proficiency|
    CharacterProficiency.create(character: new, proficiency: class_proficiency.proficiency)
  end

  # Add Hit Points
  hp = new.hit_points
  (new.level-1).times do
    hp += rand(new.player_class.hit_die-2)+2
  end
  new.update(hit_points: hp)

  # Add race and subrace bonuses
  str_bonus = new.race.ability_bonuses[1].to_i
  if new.subrace
    str_bonus = new.subrace.ability_bonuses[1].to_i if new.subrace.ability_bonuses[1].to_i > new.race.ability_bonuses[1].to_i
  end
  ability_score.update(strength: ability_score.strength += str_bonus) if str_bonus > 0

  dex_bonus = new.race.ability_bonuses[4].to_i
  if new.subrace
    dex_bonus = new.subrace.ability_bonuses[4].to_i if new.subrace.ability_bonuses[4].to_i > new.race.ability_bonuses[4].to_i
  end
  ability_score.update(dexterity: ability_score.dexterity += dex_bonus) if dex_bonus > 0

  const_bonus = new.race.ability_bonuses[7].to_i
  if new.subrace
    const_bonus = new.subrace.ability_bonuses[7].to_i if new.subrace.ability_bonuses[7].to_i > new.race.ability_bonuses[7].to_i
  end
  ability_score.update(constitution: ability_score.constitution += const_bonus) if const_bonus > 0

  int_bonus = new.race.ability_bonuses[10].to_i
  if new.subrace
    int_bonus = new.subrace.ability_bonuses[10].to_i if new.subrace.ability_bonuses[10].to_i > new.race.ability_bonuses[10].to_i
  end
  ability_score.update(intelligence: ability_score.intelligence += int_bonus) if int_bonus > 0

  wis_bonus = new.race.ability_bonuses[13].to_i
  if new.subrace
    wis_bonus = new.subrace.ability_bonuses[13].to_i if new.subrace.ability_bonuses[13].to_i > new.race.ability_bonuses[13].to_i
  end
  ability_score.update(wisdom: ability_score.wisdom += wis_bonus) if wis_bonus > 0

  cha_bonus = new.race.ability_bonuses[16].to_i
  if new.subrace
    cha_bonus = new.subrace.ability_bonuses[16].to_i if new.subrace.ability_bonuses[16].to_i > new.race.ability_bonuses[16].to_i
  end
  ability_score.update(charisma: ability_score.charisma += cha_bonus) if cha_bonus > 0


  create_proficiencies(new, ability_score)
  create_skills(new, ability_score)
end

# Create characters (2 of 2)
24.times do
  # Create character
  player_class = PlayerClass.all.sample
  player_race = Race.all.sample
  user = User.all.sample
  new = Character.create(user: user, name: Faker::Games::ElderScrolls.unique.name, level: rand(12)+3, bio: Faker::Books::Dune.unique.quote, hit_points: player_class.hit_die, player_class: player_class, race: player_race, subclass: Subclass.select{|x| x.player_class == player_class}.sample, subrace: Subrace.select{|x| x.race == player_race}.sample)

  # Create AbilityScore
  ability_score = AbilityScore.create(character: new, strength: rand(9)+8, dexterity: rand(9)+8, constitution: rand(9)+9, intelligence: rand(9)+8, wisdom: rand(9)+8, charisma: rand(9)+8)

  # Add Hit Points
  hp = new.hit_points
  (new.level-1).times do
    hp += rand(new.player_class.hit_die-2)+2+((ability_score.constitution-10)/2)
  end
  new.update(hit_points: hp)

  # Add race and subrace bonuses
  str_bonus = new.race.ability_bonuses[1].to_i
  if new.subrace
    str_bonus = new.subrace.ability_bonuses[1].to_i if new.subrace.ability_bonuses[1].to_i > new.race.ability_bonuses[1].to_i
  end
  ability_score.update(strength: ability_score.strength += str_bonus) if str_bonus > 0

  dex_bonus = new.race.ability_bonuses[4].to_i
  if new.subrace
    dex_bonus = new.subrace.ability_bonuses[4].to_i if new.subrace.ability_bonuses[4].to_i > new.race.ability_bonuses[4].to_i
  end
  ability_score.update(dexterity: ability_score.dexterity += dex_bonus) if dex_bonus > 0

  const_bonus = new.race.ability_bonuses[7].to_i
  if new.subrace
    const_bonus = new.subrace.ability_bonuses[7].to_i if new.subrace.ability_bonuses[7].to_i > new.race.ability_bonuses[7].to_i
  end
  ability_score.update(constitution: ability_score.constitution += const_bonus) if const_bonus > 0

  int_bonus = new.race.ability_bonuses[10].to_i
  if new.subrace
    int_bonus = new.subrace.ability_bonuses[10].to_i if new.subrace.ability_bonuses[10].to_i > new.race.ability_bonuses[10].to_i
  end
  ability_score.update(intelligence: ability_score.intelligence += int_bonus) if int_bonus > 0

  wis_bonus = new.race.ability_bonuses[13].to_i
  if new.subrace
    wis_bonus = new.subrace.ability_bonuses[13].to_i if new.subrace.ability_bonuses[13].to_i > new.race.ability_bonuses[13].to_i
  end
  ability_score.update(wisdom: ability_score.wisdom += wis_bonus) if wis_bonus > 0

  cha_bonus = new.race.ability_bonuses[16].to_i
  if new.subrace
    cha_bonus = new.subrace.ability_bonuses[16].to_i if new.subrace.ability_bonuses[16].to_i > new.race.ability_bonuses[16].to_i
  end
  ability_score.update(charisma: ability_score.charisma += cha_bonus) if cha_bonus > 0


  create_proficiencies(new, ability_score)
  create_skills(new, ability_score)
end

# THE LEGEND #
1.times do
  player_class = PlayerClass.all[6]
  theLegendPB = Character.create(user: User.all.sample, name: "Paul Blart the Magnificent", level: 20, bio: "Safety never takes a holiday.", race: Race.all[3], player_class: player_class, hit_points: 121, subclass: Subclass.find {|x| x.player_class == player_class})
  ability_score = AbilityScore.create(character: theLegendPB, strength: 22, dexterity: 18, constitution: 20, intelligence: 8, wisdom: 24, charisma: 30)

  create_proficiencies(theLegendPB, ability_score)
  create_skills(theLegendPB, ability_score)
end

# Create character - campaign associations
Character.all.each do |character|
  character.name == "Paul Blart the Magnificent" ? return :
  campaign = rand(6)+1 == 1 ? nil : Campaign.all.sample
  unless campaign == nil || campaign.max_players == campaign.characters.count
    CampaignCharacter.create(character: character, campaign: campaign)
  end
end


# # TO DO: Add equipment, race proficiencies, languages, character spells, images
# # Seed Equipment
# o = 0
# 256.times do
#   o += 1
#   data = JSON.parse(RestClient.get(url + "equipment/#{o}"))
#   Equipment.create(data)
# end
#
# # Seed Images
# https://loremflickr.com/320/240/dnd
