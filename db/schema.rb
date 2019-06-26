# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_26_171540) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ability_scores", force: :cascade do |t|
    t.bigint "character_id"
    t.integer "strength"
    t.integer "dexterity"
    t.integer "constitution"
    t.integer "intelligence"
    t.integer "wisdom"
    t.integer "charisma"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_ability_scores_on_character_id"
  end

  create_table "campaign_characters", force: :cascade do |t|
    t.bigint "character_id"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_characters_on_campaign_id"
    t.index ["character_id"], name: "index_campaign_characters_on_character_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "pictures"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "character_equipments", force: :cascade do |t|
    t.bigint "character_id"
    t.bigint "equipment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_equipments_on_character_id"
    t.index ["equipment_id"], name: "index_character_equipments_on_equipment_id"
  end

  create_table "character_proficiencies", force: :cascade do |t|
    t.bigint "proficiency_id"
    t.bigint "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_proficiencies_on_character_id"
    t.index ["proficiency_id"], name: "index_character_proficiencies_on_proficiency_id"
  end

  create_table "character_proficiency_choices", force: :cascade do |t|
    t.bigint "character_id"
    t.bigint "proficiency_id"
    t.string "proficiency_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_proficiency_choices_on_character_id"
    t.index ["proficiency_id"], name: "index_character_proficiency_choices_on_proficiency_id"
  end

  create_table "character_spells", force: :cascade do |t|
    t.bigint "character_id"
    t.bigint "spell_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_spells_on_character_id"
    t.index ["spell_id"], name: "index_character_spells_on_spell_id"
  end

  create_table "characters", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.integer "level"
    t.text "bio"
    t.bigint "race_id"
    t.bigint "player_class_id"
    t.bigint "subclass_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_class_id"], name: "index_characters_on_player_class_id"
    t.index ["race_id"], name: "index_characters_on_race_id"
    t.index ["subclass_id"], name: "index_characters_on_subclass_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "class_proficiencies", force: :cascade do |t|
    t.bigint "player_class_id"
    t.bigint "proficiency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_class_id"], name: "index_class_proficiencies_on_player_class_id"
    t.index ["proficiency_id"], name: "index_class_proficiencies_on_proficiency_id"
  end

  create_table "class_proficiency_choices", force: :cascade do |t|
    t.bigint "player_class_id"
    t.bigint "proficiency_id"
    t.string "proficiency_type"
    t.integer "choices"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_class_id"], name: "index_class_proficiency_choices_on_player_class_id"
    t.index ["proficiency_id"], name: "index_class_proficiency_choices_on_proficiency_id"
  end

  create_table "class_spells", force: :cascade do |t|
    t.bigint "player_class_id"
    t.bigint "subclass_id"
    t.bigint "spell_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_class_id"], name: "index_class_spells_on_player_class_id"
    t.index ["spell_id"], name: "index_class_spells_on_spell_id"
    t.index ["subclass_id"], name: "index_class_spells_on_subclass_id"
  end

  create_table "dm_campaigns", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_dm_campaigns_on_campaign_id"
    t.index ["user_id"], name: "index_dm_campaigns_on_user_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.string "name"
    t.string "equipment_category"
    t.string "equipment_subcategory"
    t.string "cost"
    t.text "details"
    t.string "weapon_range"
    t.string "capacity"
    t.string "speed"
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "features", force: :cascade do |t|
    t.string "name"
    t.bigint "player_class_id"
    t.integer "level"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_class_id"], name: "index_features_on_player_class_id"
  end

  create_table "followings", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "following_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_classes", force: :cascade do |t|
    t.string "name"
    t.integer "hit_die"
    t.string "saving_throws"
    t.text "starting_equipment"
    t.text "class_levels"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proficiencies", force: :cascade do |t|
    t.string "category"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "race_traits", force: :cascade do |t|
    t.bigint "race_id"
    t.bigint "trait_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_race_traits_on_race_id"
    t.index ["trait_id"], name: "index_race_traits_on_trait_id"
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.integer "speed"
    t.string "ability_bonuses"
    t.text "alignment"
    t.text "age"
    t.string "size"
    t.text "size_desc"
    t.string "languages"
    t.text "language_desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.bigint "character_id"
    t.integer "athletics"
    t.integer "acrobatics"
    t.integer "sleight_of_hand"
    t.integer "stealth"
    t.integer "arcana"
    t.integer "history"
    t.integer "investigation"
    t.integer "nature"
    t.integer "religion"
    t.integer "animal_handling"
    t.integer "insight"
    t.integer "medicine"
    t.integer "perception"
    t.integer "survival"
    t.integer "deception"
    t.integer "intimidation"
    t.integer "performance"
    t.integer "persuasion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_skills_on_character_id"
  end

  create_table "spellcastings", force: :cascade do |t|
    t.string "ability"
    t.bigint "player_class_id"
    t.integer "level"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_class_id"], name: "index_spellcastings_on_player_class_id"
  end

  create_table "spells", force: :cascade do |t|
    t.string "name"
    t.text "desc"
    t.integer "level"
    t.text "higher_level"
    t.string "range"
    t.string "components"
    t.text "material"
    t.string "duration"
    t.boolean "ritual"
    t.boolean "concentration"
    t.string "casting_time"
    t.string "school"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subclasses", force: :cascade do |t|
    t.string "name"
    t.bigint "player_class_id"
    t.string "flavor"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_class_id"], name: "index_subclasses_on_player_class_id"
  end

  create_table "traits", force: :cascade do |t|
    t.string "name"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 30
    t.string "name"
    t.string "password_digest"
    t.text "bio"
    t.string "email"
    t.integer "age"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "weapon_properties", force: :cascade do |t|
    t.bigint "equipment_id"
    t.string "name"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_weapon_properties_on_equipment_id"
  end

  add_foreign_key "ability_scores", "characters"
  add_foreign_key "campaign_characters", "campaigns"
  add_foreign_key "campaign_characters", "characters"
  add_foreign_key "character_equipments", "characters"
  add_foreign_key "character_equipments", "equipment"
  add_foreign_key "character_proficiencies", "characters"
  add_foreign_key "character_proficiencies", "proficiencies"
  add_foreign_key "character_proficiency_choices", "characters"
  add_foreign_key "character_proficiency_choices", "proficiencies"
  add_foreign_key "character_spells", "characters"
  add_foreign_key "character_spells", "spells"
  add_foreign_key "characters", "player_classes"
  add_foreign_key "characters", "races"
  add_foreign_key "characters", "subclasses"
  add_foreign_key "characters", "users"
  add_foreign_key "class_proficiencies", "player_classes"
  add_foreign_key "class_proficiencies", "proficiencies"
  add_foreign_key "class_proficiency_choices", "player_classes"
  add_foreign_key "class_proficiency_choices", "proficiencies"
  add_foreign_key "class_spells", "player_classes"
  add_foreign_key "class_spells", "spells"
  add_foreign_key "class_spells", "subclasses"
  add_foreign_key "dm_campaigns", "campaigns"
  add_foreign_key "dm_campaigns", "users"
  add_foreign_key "features", "player_classes"
  add_foreign_key "race_traits", "races"
  add_foreign_key "race_traits", "traits"
  add_foreign_key "skills", "characters"
  add_foreign_key "spellcastings", "player_classes"
  add_foreign_key "subclasses", "player_classes"
end
