# This seed file makes a bunch of calls to this D&D API:
# http://www.dnd5eapi.co/
#
# Current call count: 941 (1197 w/ equipment)
#
# Please allow up to 10 minutes for the seed file to run

# Define base URL
url = "http://www.dnd5eapi.co/api/"


# Reset Characters and User Related Models
AbilityScore.destroy_all
Skill.destroy_all
CharacterProficiency.destroy_all
CampaignCharacter.destroy_all
Character.destroy_all

AbilityScore.reset_pk_sequence
Skill.reset_pk_sequence
CharacterProficiency.reset_pk_sequence
CampaignCharacter.reset_pk_sequence
Character.reset_pk_sequence

DmCampaign.destroy_all
DmCampaign.reset_pk_sequence
CampaignOwner.destroy_all
CampaignOwner.reset_pk_sequence

Following.destroy_all
Following.reset_pk_sequence

User.destroy_all
User.reset_pk_sequence


puts "creating users and followings..."
# Create Sample Users
z = 1
18.times do
  User.create(username:"test#{z}", name: Faker::Name.first_name + " " + Faker::Name.last_name, email:Faker::Internet.email, bio:Faker::Hipster.sentence(4, false, 4), age:rand(33)+17, location:"#{Faker::Address.city}, #{Faker::Address.state_abbr}", password:"test")
  z += 1
end


# Seed followers/following
63.times do
  user1 = User.all.sample
  user2 = User.all.sample
  unless user1 == user2
    Following.create(follower: user1, following: user2)
  end
end


# Delete and reset core game info classes

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
CharacterProficiency.destroy_all
CharacterProficiencyChoice.destroy_all
ClassSpell.destroy_all
Proficiency.destroy_all
Spell.destroy_all
Trait.destroy_all
Subrace.destroy_all
Race.destroy_all
Subclass.destroy_all
PlayerClass.destroy_all


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
CharacterProficiency.reset_pk_sequence
CharacterProficiencyChoice.reset_pk_sequence
ClassSpell.reset_pk_sequence
Proficiency.reset_pk_sequence
Spell.reset_pk_sequence
Trait.reset_pk_sequence
Subrace.reset_pk_sequence
Race.reset_pk_sequence
Subclass.reset_pk_sequence
PlayerClass.reset_pk_sequence


print "seeding core game data."
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

print '.'
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

print '.'
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

# Seed subraces, RaceProficiency and RaceTrait tables
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

print '.'
# Seed Features
s = 0
414.times do
  s += 1
  data = JSON.parse(RestClient.get(url + "features/#{s}"))
  Feature.create(name: data['name'], player_class: PlayerClass.find{|pc| pc.name == data['class']['name']}, level: data['level'], desc: data['desc'].join('<<|>>'))
  print '.' if s === 207
end

# Seed Spellcasting info
q = 0
8.times do
  q += 1
  data = JSON.parse(RestClient.get(url + "spellcasting/#{q}"))

  Spellcasting.create(ability: data['spellcasting_ability']['name'], player_class: PlayerClass.find{|pc| pc.name == data['class']['name']}, level: data['level'], info: data['info'].map{|info| info['name'] + ": " + info['desc'][0]}.join('<<|>>').gsub(/â€™/, "'").gsub(/â€�/, '"').gsub(/â€œ/, '"'))
end

print '.'
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
  print '.' if n === 160
end




puts "\ncreating campaigns..."
# Create campaigns
Messages.destroy_all
Messages.reset_pk_sequence
Chat.destroy_all
Chat.reset_pk_sequence
Campaign.destroy_all
Campaign.reset_pk_sequence

c1 = Campaign.create(name: "Curse of Strahd", description: "The master of nearby Castle Ravenloft, Count Strahd von Zarovich, tyrannically rules the country, and the residents must barricade their doors each night to avoid attacks by Strahd and his minions. The Burgomaster's mansion is the focus of these attacks, and, for reasons that are not explained, Strahd is after the Burgomaster's adopted daughter, Ireena Kolyana. There are four possible motivations for Strahd. He may want to replace one of the PCs and attempt to turn the character into a vampire and take on that character's form. He may desire the love of Ireena, whose appearance matches that of his lost love, Tatyana. Using mind control, Strahd will try to force a PC to attack Ireena and gain her love by 'saving' her from the situation he created. Strahd may also want to create an evil magic item, or destroy the Sunsword.", max_players: rand(6)+6, open_invite: true)
c1.update(open_invite: false) if rand(4) == 1

c2 = Campaign.create(name: "Ghosts of Saltmarsh", description: "Desolate and abandoned, the evil alchemist's mansion stands alone on the cliff, looking out towards the sea. Mysterious lights and ghostly hauntings have kept away the people of Saltmarsh, despite rumors of fabulous forgotten treasure. What is its sinister secret?", max_players: rand(6)+6, open_invite: true)
c2.update(open_invite: false) if rand(4) == 1

c3 = Campaign.create(name: "Hoard of the Dragon Queen", description: "In an audacious bid for power, the Cult of the Dragon, along with its dragon allies and the Red Wizards of Thay, seek to bring Tiamat from her prison in the Nine Hells to Faerûn. To this end, they are sweeping from town to town, laying waste to all those who oppose them and gathering a hoard of riches for their dread queen. The threat of annihilation has become so dire that groups as disparate as the Harpers and Zhentarim are banding together in the fight against the cult. Never before has the need for heroes been so desperate.", max_players: rand(6)+6, open_invite: true)
c3.update(open_invite: false) if rand(4) == 1

c4 = Campaign.create(name: "Out of the Abyss", description: "The Underdark is a subterranean wonderland, a vast and twisted labyrinth where fear reigns. It is the home of horrific monsters that have never seen the light of day. It is here that the dark elf Gromph Baenre, Archmage of Menzoberranzan, casts a foul spell meant to ignite a magical energy that suffuses the Underdark and tears open portals to the demonic Abyss. What steps through surprises even him, and from that moment on, the insanity that pervades the Underdark escalates and threatens to shake the Forgotten Realms to its foundations. Stop the madness before it consumes you!", max_players: rand(6)+6, open_invite: true)
c4.update(open_invite: false) if rand(4) == 1

c5 = Campaign.create(name: "Tales from the Yawning Portal", description: "When the shadows grow long in Waterdeep and the fireplace in the taproom of the Yawning Portal dims to a deep crimson glow, adventurers from across the Forgotten Realms, and even from other worlds, spin tales and spread rumors of dark dungeons and lost treasures. Some of the yarns overheard by Durnan, the barkeep of the Yawning Portal, are inspired by places and events in far-flung lands from across the D&D multiverse, and these tales have been collected into a single volume.", max_players: rand(6)+6, open_invite: true)
c5.update(open_invite: false) if rand(4) == 1

c6 = Campaign.create(name: "Return of Tiamat", description: "The Cult of the Dragon leads the charge in an unholy crusade to bring Tiamat back to the Realms, and the situation grows more perilous for good people with each passing moment. The battle becomes increasingly political as opportunities to gather allies and gain advantage present themselves. From Waterdeep to the Sea of Moving Ice to Thay, it is a race against Evil. Succeed or succumb to the oppression of draconic tyranny. Win or lose, things will never be the same again.", max_players: rand(6)+6, open_invite: true)
c6.update(open_invite: false) if rand(4) == 1

c7 = Campaign.create(name: "Princes of the Apocolypse", description: "A terrible threat gathers in the North. Throughout this region of the Forgotten Realms, savage marauders bring destruction. Monsters are on the prowl, preying on flocks, rampaging through croplands, and attacking homesteads and travelers. In settlements, discord and suspicion grow. Sinister strangers lurk in the shadows, whispering about how everything is soon to change.", max_players: rand(6)+6, open_invite: true)
c7.update(open_invite: false) if rand(4) == 1

c8 = Campaign.create(name: "Death House", description: "Death House is the name given to an old row house in the village of Barovia. The house has been burned to the ground many times, only to rise from the ashes time and again—by its own will or that of Strahd. Locals give the building a wide berth for fear of antagonizing the evil spirits believed to haunt it.", max_players: rand(6)+6, open_invite: true)
c8.update(open_invite: false) if rand(4) == 1

c9 = Campaign.create(name: "Tyranny in Phlan", description: "Things are changing in Phlan, and for the worse. The Cult of the Dragon has spies deeply rooted in the castle and has been corrupting many of the town’s defenders, gathering new allies and otherwise readying to make a move for control of the town and the Pool of Radiance that lies beneath it. Knight Commander Ector Brahms, the Lord Regent of Phlan, has called a secret summit of the masters of the town’s four major guilds and the head of each noble house. At the foot of the Cinnabar Throne, he plans to hammer out the terms of an alliance and bring order and peace to the town once and for all. It is here, however, that the hammer will fall in the form of Vorgansharax, the Maimed Virulence: a green dragon who has allied himself with the Cult of the Dragon in exchange for dominion over Phlan.", max_players: rand(6)+6, open_invite: true)
c9.update(open_invite: false) if rand(4) == 1

c10 = Campaign.create(name: "A Wild Sheep Chase", description: "The party’s attempt to grab a rare afternoon of downtime is interrupted by a frantic sheep equipped with a Scroll of Speak to Animals and a fierce determination to get their attention. With the aid of some magic, the creature reveals itself to be no mere beast, but a wizard who fell victim to an embittered apprentice and a stolen Wand of True Polymorph.
After two years imprisoned with nothing to eat but his own lawn, the ex-elf has escaped and is in dire need of aid. Transformed assassins are looking to grab themselves a mutton dinner, while the only object capable of restoring his opposable thumbs lies in the hands of his former pupil and current nemesis. Fortunately, the wooly wizard has found new allies he can rely on, right?", max_players: rand(6)+6, open_invite: true)
c10.update(open_invite: false) if rand(4) == 1

c11 = Campaign.create(name: "The Wolves of Welton", description: "It’s been a long time since the people of Welton have worried about anything more frightening than sheep ticks or a late frost, but now a pack of strangely determined wolves is driving farmers from their fields and spiriting away entire flocks in the middle of the night.
With food supplies running low and their sorcerer-in-residence nowhere to be found, the village council sends out a desperate plea for brave adventurers to destroy the beasts for good. Is the job as easy as a walk in the woods, or is there more to the Wolves of Welton than mere animal cunning? There's only one way to find out…", max_players: rand(6)+6, open_invite: true)
c11.update(open_invite: false) if rand(4) == 1

c12 = Campaign.create(name: "The Fiery Grog", description: "The Fiery Grog is a popular watering hole for the more rough and tumble folk of Port Myrandu. The seedy tavern is often the meeting place for shady dealings kept hidden by the loud drunken activities that permeate the building each night.
Whether your adventurers are meeting an important NPC in private, they’re in need of a quest hook or two to move the adventure forward, or looking to blow off some steam by partying hard and maybe get into a brawl, the Fiery Grog is the place to go.", max_players: rand(6)+6, open_invite: true)
c12.update(open_invite: false) if rand(4) == 1

c13 = Campaign.create(name: "Madness of the Rat King", description: "An ambitious were-rat alchemist known only as 'the Rat King' set up a base of operations down in these caverns a year ago. He has been working tirelessly in his laboratory since then, using alchemy and magic to mutate and breed loyal rat minions to suit his needs: for example, combining rats with aberrant beholder essence to create loyal 'laser rats' with the ability to float and shoot fiery rays, as alchemists are wont to do.
The initial motives for the Rat King’s experimentation is a mystery even to himself. At some point during his time in these caverns, a dark influence took hold of him, slowly driving him insane. The Rat King now has one clear goal in his crazed mind: to create an army of mutant rats and take over the surface, to escape and protect the world from what he calls “the Old Voice,” a malicious entity that whispers to him endlessly from the deep.", max_players: rand(6)+6, open_invite: true)
c13.update(open_invite: false) if rand(4) == 1

c14 = Campaign.create(name: "Seven Weddings", description: "Lilian was a witch who studied the arcane in a hamlet called Lukestown. Her love of mysticisms was only eclipsed by her love for her fiancé Marcus. Lilian loved him so much, she began crafting a pair of magical rings that would grant her and Marcus immortality. However, the powerful magics involved were well beyond Lilian’s skills. One night while working on the rings, the life and death magics went awry, killing Lilian.
Marcus was crushed. They laid Lilian to rest in the town’s mausoleum. It was not long before Lilian's spirit rose, fueled by her own foul magics. Marcus tried to visit, but over time, Lilian grew more and more hateful. Marcus stopped visiting when it became clear her undead nature had overpowered any humanity left within.", max_players: rand(6)+6, open_invite: true)
c14.update(open_invite: false) if rand(4) == 1

# # Sylwia easter egg
# Campaign.create(
#   name: "Sylwia's Candy Kingdom",
#   description: "Oh save the candy floss!",
#   max_players: 14,
#   open_invite: true
# )

# Create DM's, Chats, and Ownerships
Campaign.all.each do |campaign|
  if rand(3) > 0
    DmCampaign.create(campaign: campaign, user: User.all.sample)
  end

  Chat.create(campaign: campaign)

  if rand(4)+1 > 3
    CampaignOwner.create(campaign: campaign, user: User.all.sample)
  else
    CampaignOwner.create(campaign: campaign, user: campaign.dm_campaigns.map(&:user)[0])
  end
end




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

puts "creating characters..."
# Create characters main function
def create_character(name)
  player_class = PlayerClass.all.sample
  player_race = Race.all.sample
  user = User.all.sample
  level = rand(15)+1
  new = Character.create(user: user, name: name, level: level, bio: Faker::Books::Dune.unique.quote, hit_points: player_class.hit_die, hp_levels: level, player_class: player_class, race: player_race, subclass: Subclass.select{|x| x.player_class == player_class}.sample, subrace: Subrace.select{|x| x.race == player_race}.sample)

  # Create AbilityScore
  ability_score = AbilityScore.create(character: new, strength: rand(9)+8, dexterity: rand(9)+8, constitution: rand(9)+9, intelligence: rand(9)+8, wisdom: rand(9)+8, charisma: rand(9)+8)

  # Add Hit Points
  hp = new.hit_points
  (new.level-1).times do
    hp += rand(new.player_class.hit_die-3)+2+((ability_score.constitution-10)/2)
  end
  new.update(hit_points: hp)

  # Create character proficiencies
  player_class.class_proficiencies.each do |class_proficiency|
    CharacterProficiency.create(character: new, proficiency: class_proficiency.proficiency)
  end

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


# Create character names (1 of 3)
# total: 33 unique names
16.times do
  name = Faker::Games::WorldOfWarcraft.unique.hero
  create_character(name)
end

# Create character names (2 of 3)
# total: 85 unique names
24.times do
  name = Faker::Games::Witcher.unique.character
  create_character(name)
end

# Create character names (3 of 3)
# total: 3150 unique names
32.times do
  name = Faker::Games::ElderScrolls.unique.name
  create_character(name)
end

# # Sylwia easter egg
# sylw = Character.create(
#   name: "Sylwia",
#   level: 20,
#   hit_points: 12,
#   hp_levels: 1,
#   bio: "Sylwia sleeps a lot.",
#   player_class_id: 1,
#   subclass_id: 1,
#   race_id: 5,
#   subrace_id: nil
# )
#
# sylw.player_class.class_proficiencies.each do |class_proficiency|
#   CharacterProficiency.create(character: sylw, proficiency: class_proficiency.proficiency)
# end
#
# ability_score = AbilityScore.create(character: sylw, strength: 22, dexterity: 18, constitution: 20, intelligence: 8, wisdom: 24, charisma: 30)
#
# create_proficiencies(sylw, ability_score)
# create_skills(sylw, ability_score)
#
# # THE LEGEND #
# # (Gino easter egg) # #
# 1.times do
#   player_class = PlayerClass.all[6]
#   theLegendPB = Character.create(user: User.all.sample, name: "Paul Blart the Magnificent", level: 20, bio: "Safety never takes a holiday.", race: Race.all[3], player_class: player_class, hit_points: 161, hp_levels: 20, subclass: Subclass.find {|x| x.player_class == player_class})
#   ability_score = AbilityScore.create(character: theLegendPB, strength: 22, dexterity: 18, constitution: 20, intelligence: 8, wisdom: 24, charisma: 30)
#
# theLegendPB.player_class.class_proficiencies.each do |class_proficiency|
#   CharacterProficiency.create(character: theLegendPB, proficiency: class_proficiency.proficiency)
# end
#
#   create_proficiencies(theLegendPB, ability_score)
#   create_skills(theLegendPB, ability_score)
# end

puts "finishing campaign associations..."
# Create character/campaign associations
Character.all.each do |character|
  character.name == "Paul Blart the Magnificent" ? return :
  campaign = Campaign.all.sample
  unless campaign == nil || campaign.max_players == campaign.characters.count || rand(7) == 0
    CampaignCharacter.create(character: character, campaign: campaign)
  end
end

# Create additional max_players for Campaigns
Campaign.all.each do |campaign|
  if rand(2) > 0
    campaign.update(max_players: campaign.max_players+2)
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

puts "done!"
