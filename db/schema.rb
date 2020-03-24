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

ActiveRecord::Schema.define(version: 2019_07_02_191113) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_list", primary_key: "active_list_id", force: :cascade do |t|
    t.integer "active_list_type_id", null: false
    t.bigint "person_id", null: false
    t.integer "concept_id", null: false
    t.bigint "start_obs_id"
    t.bigint "stop_obs_id"
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.string "comments", limit: 255
    t.bigint "creator", null: false
    t.datetime "date_created", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
  end

  create_table "active_list_allergy", primary_key: "active_list_id", force: :cascade do |t|
    t.string "allergy_type", limit: 50
    t.integer "reaction_concept_id"
    t.string "severity", limit: 50
  end

  create_table "active_list_problem", primary_key: "active_list_id", force: :cascade do |t|
    t.string "status", limit: 50
    t.float "sort_weight"
  end

  create_table "active_list_type", primary_key: "active_list_type_id", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "description", limit: 255
    t.bigint "creator", null: false
    t.datetime "date_created", null: false
    t.integer "retired", default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
  end

  create_table "alternative_drug_names", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "short_name", limit: 255
    t.integer "drug_inventory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cohort", primary_key: "cohort_id", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "description", limit: 1000
    t.bigint "creator", null: false
    t.datetime "date_created", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
  end

  create_table "cohort_member", primary_key: ["cohort_id", "patient_id"], force: :cascade do |t|
    t.integer "cohort_id", default: 0, null: false
    t.bigint "patient_id", default: 0, null: false
  end

  create_table "complex_obs", primary_key: "obs_id", id: :bigint, default: 0, force: :cascade do |t|
    t.integer "mime_type_id", default: 0, null: false
    t.text "urn"
    t.text "complex_value"
  end

  create_table "concept", primary_key: "concept_id", id: :serial, force: :cascade do |t|
    t.integer "retired", limit: 2, default: 0, null: false
    t.string "short_name", limit: 255
    t.text "description"
    t.text "form_text"
    t.integer "datatype_id", default: 0, null: false
    t.integer "class_id", default: 0, null: false
    t.integer "is_set", limit: 2, default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "default_charge"
    t.string "version", limit: 50
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
  end

  create_table "concept_answer", primary_key: "concept_answer_id", id: :serial, force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.integer "answer_concept"
    t.integer "answer_drug"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.string "uuid", limit: 38, null: false
    t.float "sort_weight"
  end

  create_table "concept_class", primary_key: "concept_class_id", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.string "description", limit: 255, default: "", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "concept_class_uuid_key", unique: true
  end

  create_table "concept_complex", primary_key: "concept_id", id: :integer, default: nil, force: :cascade do |t|
    t.string "handler", limit: 255
  end

  create_table "concept_datatype", primary_key: "concept_datatype_id", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.string "hl7_abbreviation", limit: 3
    t.string "description", limit: 255, default: "", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "concept_datatype_uuid_key", unique: true
  end

  create_table "concept_derived", primary_key: "concept_id", id: :integer, default: 0, force: :cascade do |t|
    t.string "rule", limit: 255
    t.datetime "compile_date"
    t.string "compile_status", limit: 255
    t.string "class_name", limit: 1024
  end

  create_table "concept_description", primary_key: "concept_description_id", id: :serial, force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.text "description", null: false
    t.string "locale", limit: 50, default: "", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "concept_description_uuid_key", unique: true
  end

  create_table "concept_map", primary_key: "concept_map_id", id: :serial, force: :cascade do |t|
    t.integer "source"
    t.string "source_code", limit: 255
    t.string "comment", limit: 255
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "concept_id", default: 0, null: false
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "concept_map_uuid_key", unique: true
  end

  create_table "concept_name", primary_key: "concept_name_id", id: :serial, force: :cascade do |t|
    t.integer "concept_id"
    t.string "name", limit: 255, default: "", null: false
    t.string "locale", limit: 50, default: "", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.string "concept_name_type", limit: 50
    t.integer "locale_preferred", limit: 2, default: 0
  end

  create_table "concept_name_tag", primary_key: "concept_name_tag_id", id: :serial, force: :cascade do |t|
    t.string "tag", limit: 50, null: false
    t.text "description", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
  end

  create_table "concept_name_tag_map", id: false, force: :cascade do |t|
    t.integer "concept_name_id", null: false
    t.integer "concept_name_tag_id", null: false
  end

  create_table "concept_numeric", primary_key: "concept_id", id: :integer, default: 0, force: :cascade do |t|
    t.float "hi_absolute"
    t.float "hi_critical"
    t.float "hi_normal"
    t.float "low_absolute"
    t.float "low_critical"
    t.float "low_normal"
    t.string "units", limit: 50
    t.integer "precise", limit: 2, default: 0, null: false
  end

  create_table "concept_proposal", primary_key: "concept_proposal_id", id: :serial, force: :cascade do |t|
    t.integer "concept_id"
    t.bigint "encounter_id"
    t.string "original_text", limit: 255, default: "", null: false
    t.string "final_text", limit: 255
    t.bigint "obs_id"
    t.integer "obs_concept_id"
    t.string "state", limit: 32, default: "UNMAPPED", null: false
    t.string "comments", limit: 255
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "locale", limit: 50, default: "", null: false
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "concept_proposal_uuid_key", unique: true
  end

  create_table "concept_proposal_tag_map", id: false, force: :cascade do |t|
    t.integer "concept_proposal_id", null: false
    t.integer "concept_name_tag_id", null: false
  end

  create_table "concept_set", primary_key: "concept_set_id", id: :serial, force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.integer "concept_set", default: 0, null: false
    t.float "sort_weight"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "concept_set_uuid_key", unique: true
  end

  create_table "concept_set_derived", primary_key: ["concept_id", "concept_set"], force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.integer "concept_set", default: 0, null: false
    t.float "sort_weight"
  end

  create_table "concept_source", primary_key: "concept_source_id", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50, default: "", null: false
    t.text "description", null: false
    t.string "hl7_code", limit: 50
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "concept_source_uuid_key", unique: true
  end

  create_table "concept_state_conversion", primary_key: "concept_state_conversion_id", id: :serial, force: :cascade do |t|
    t.integer "concept_id", default: 0
    t.integer "program_workflow_id", default: 0
    t.integer "program_workflow_state_id", default: 0
    t.string "uuid", limit: 38, null: false
    t.index ["program_workflow_id", "concept_id"], name: "concept_state_conversion_program_workflow_id_concept_id_key", unique: true
    t.index ["uuid"], name: "concept_state_conversion_uuid_key", unique: true
  end

  create_table "concept_synonym", primary_key: "concept_id", id: :integer, default: 0, force: :cascade do |t|
    t.string "synonym", limit: 255, default: "", null: false
    t.string "locale", limit: 255
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.index ["creator"], name: "concept_synonym_creator_key", unique: true
  end

  create_table "concept_word", primary_key: "concept_word_id", id: :serial, force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.string "word", limit: 50, default: "", null: false
    t.string "locale", limit: 20, default: "", null: false
    t.integer "concept_name_id", null: false
    t.index ["concept_name_id"], name: "concept_word_concept_name_id_key", unique: true
    t.index ["word"], name: "concept_word_word_key", unique: true
  end

  create_table "couch_updates", force: :cascade do |t|
    t.string "doc_id", null: false
    t.string "doc_type", null: false
    t.text "doc", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "queue_count", default: 0
  end

  create_table "district", primary_key: "district_id", force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.integer "region_id", default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
  end

  create_table "districts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drug", primary_key: "drug_id", id: :serial, force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.string "name", limit: 50
    t.integer "combination", limit: 2, default: 0, null: false
    t.integer "dosage_form"
    t.float "dose_strength"
    t.float "maximum_daily_dose"
    t.float "minimum_daily_dose"
    t.integer "route"
    t.string "units", limit: 50
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "drug_uuid_key", unique: true
  end

  create_table "drug_cms", primary_key: "drug_inventory_id", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "code", limit: 255
    t.string "short_name", limit: 225
    t.string "tabs", limit: 225
    t.integer "pack_size"
    t.integer "weight"
    t.string "strength", limit: 255
    t.integer "voided", limit: 2, default: 0
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 225
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drug_ingredient", primary_key: ["ingredient_id", "concept_id"], force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.integer "ingredient_id", default: 0, null: false
  end

  create_table "drug_ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drug_order", primary_key: "order_id", id: :bigint, default: 0, force: :cascade do |t|
    t.integer "drug_inventory_id", default: 0
    t.float "dose"
    t.float "equivalent_daily_dose"
    t.string "units", limit: 255
    t.string "frequency", limit: 255
    t.integer "prn", limit: 2, default: 0, null: false
    t.integer "complex", limit: 2, default: 0, null: false
    t.integer "quantity"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "drug_order_barcodes", primary_key: "drug_order_barcode_id", force: :cascade do |t|
    t.integer "drug_id"
    t.integer "tabs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drug_set", primary_key: "drug_set_id", force: :cascade do |t|
    t.integer "drug_inventory_id"
    t.integer "set_id"
    t.string "frequency", limit: 255, null: false
    t.string "duration", limit: 255, null: false
    t.datetime "date_created"
    t.datetime "date_updated"
    t.bigint "creator"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
  end

  create_table "dset", primary_key: "set_id", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.bigint "creator", null: false
    t.string "status", limit: 25, null: false
  end

  create_table "encounter", primary_key: "encounter_id", force: :cascade do |t|
    t.integer "encounter_type", null: false
    t.bigint "patient_id", default: 0, null: false
    t.bigint "provider_id", default: 0, null: false
    t.integer "location_id"
    t.integer "form_id"
    t.datetime "encounter_datetime", default: "1900-01-01 00:00:00", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "program_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "encounter_type", primary_key: "encounter_type_id", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50, default: "", null: false
    t.text "description"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "encounter_type_uuid_key", unique: true
  end

  create_table "external_source", primary_key: "external_source_id", force: :cascade do |t|
    t.integer "source", default: 0, null: false
    t.string "source_code", limit: 255, null: false
    t.string "name", limit: 255
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
  end

  create_table "field", primary_key: "field_id", force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.text "description"
    t.integer "field_type"
    t.integer "concept_id"
    t.string "table_name", limit: 50
    t.string "attribute_name", limit: 50
    t.text "default_value"
    t.integer "select_multiple", limit: 2, default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
  end

  create_table "field_answer", primary_key: ["field_id", "answer_id"], force: :cascade do |t|
    t.integer "field_id", default: 0, null: false
    t.integer "answer_id", default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "field_answer_uuid_key", unique: true
  end

  create_table "field_type", primary_key: "field_type_id", force: :cascade do |t|
    t.string "name", limit: 50
    t.text "description"
    t.integer "is_set", limit: 2, default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.string "uuid", limit: 38, null: false
  end

  create_table "form", primary_key: "form_id", force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.string "version", limit: 50, default: "", null: false
    t.integer "build"
    t.integer "published", limit: 2, default: 0, null: false
    t.text "description"
    t.integer "encounter_type"
    t.text "template"
    t.text "xslt"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retired_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "form_uuid_key", unique: true
  end

  create_table "form2program_map", primary_key: ["program", "encounter_type"], force: :cascade do |t|
    t.integer "program", null: false
    t.integer "encounter_type", null: false
    t.bigint "creator", null: false
    t.datetime "date_created", null: false
    t.bigint "changed_by", null: false
    t.datetime "date_changed", null: false
    t.integer "applied", limit: 2, default: 0, null: false
  end

  create_table "form_field", primary_key: "form_field_id", force: :cascade do |t|
    t.integer "form_id", default: 0, null: false
    t.integer "field_id", default: 0, null: false
    t.integer "field_number"
    t.string "field_part", limit: 5
    t.integer "page_number"
    t.integer "parent_form_field"
    t.integer "min_occurs"
    t.integer "max_occurs"
    t.integer "required", limit: 2, default: 0, null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.float "sort_weight"
    t.string "uuid", limit: 38, null: false
  end

  create_table "formentry_archive", primary_key: "formentry_archive_id", force: :cascade do |t|
    t.text "form_data", null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "creator", default: 0, null: false
  end

  create_table "formentry_error", primary_key: "formentry_error_id", force: :cascade do |t|
    t.text "form_data", null: false
    t.string "error", limit: 255, default: "", null: false
    t.text "error_details"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
  end

  create_table "formentry_queue", primary_key: "formentry_queue_id", force: :cascade do |t|
    t.text "form_data", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
  end

  create_table "formentry_xsn", primary_key: "formentry_xsn_id", force: :cascade do |t|
    t.integer "form_id", null: false
    t.binary "xsn_data", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "archived", default: 0, null: false
    t.bigint "archived_by"
    t.datetime "date_archived"
  end

  create_table "general_sets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "global_property", primary_key: "property", id: :binary, default: "", force: :cascade do |t|
    t.text "property_value"
    t.text "description"
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "global_property_uuid_key", unique: true
  end

  create_table "heart_beat", force: :cascade do |t|
    t.string "ip", limit: 20
    t.string "property", limit: 200
    t.string "value", limit: 200
    t.datetime "time_stamp"
    t.string "username", limit: 10
    t.string "url", limit: 100
  end

  create_table "hl7_in_archive", primary_key: "hl7_in_archive_id", force: :cascade do |t|
    t.integer "hl7_source", default: 0, null: false
    t.string "hl7_source_key", limit: 255
    t.text "hl7_data", null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "message_state", default: 2
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "hl7_in_archive_uuid_key", unique: true
  end

  create_table "hl7_in_error", primary_key: "hl7_in_error_id", force: :cascade do |t|
    t.integer "hl7_source", default: 0, null: false
    t.text "hl7_source_key"
    t.text "hl7_data", null: false
    t.string "error", limit: 255, default: "", null: false
    t.text "error_details"
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "hl7_in_error_uuid_key", unique: true
  end

  create_table "hl7_in_queue", primary_key: "hl7_in_queue_id", force: :cascade do |t|
    t.integer "hl7_source", default: 0, null: false
    t.text "hl7_source_key"
    t.text "hl7_data", null: false
    t.integer "message_state", default: 0, null: false
    t.datetime "date_processed"
    t.text "error_msg"
    t.datetime "date_created"
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "hl7_in_queue_uuid_key", unique: true
  end

  create_table "hl7_source", primary_key: "hl7_source_id", force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.string "description"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "hl7_source_uuid_key", unique: true
  end

  create_table "htmlformentry_html_form", force: :cascade do |t|
    t.integer "form_id"
    t.string "name", limit: 100, null: false
    t.text "xml_data", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
  end

  create_table "labs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "liquibasechangelog", primary_key: ["id", "author", "filename"], force: :cascade do |t|
    t.string "id", limit: 63, null: false
    t.string "author", limit: 63, null: false
    t.string "filename", limit: 200, null: false
    t.datetime "dateexecuted", null: false
    t.string "md5sum", limit: 32
    t.string "description", limit: 255
    t.string "comments", limit: 255
    t.string "tag", limit: 255
    t.string "liquibase", limit: 10
  end

  create_table "liquibasechangeloglock", id: :integer, default: nil, force: :cascade do |t|
    t.integer "locked", limit: 2, null: false
    t.datetime "lockgranted"
    t.string "lockedby", limit: 255
  end

  create_table "location", primary_key: "location_id", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.string "description", limit: 255
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "city_village", limit: 50
    t.string "state_province", limit: 50
    t.string "postal_code", limit: 50
    t.string "country", limit: 50
    t.string "latitude", limit: 50
    t.string "longitude", limit: 50
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.string "county_district", limit: 50
    t.string "neighborhood_cell", limit: 50
    t.string "region", limit: 50
    t.string "subregion", limit: 50
    t.string "township_division", limit: 50
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.integer "location_type_id"
    t.integer "parent_location"
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "location_uuid_key", unique: true
  end

  create_table "location_tag", primary_key: "location_tag_id", force: :cascade do |t|
    t.string "name", limit: 50
    t.string "description", limit: 255
    t.bigint "creator", null: false
    t.datetime "date_created", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "location_tag_uuid_key", unique: true
  end

  create_table "location_tag_map", primary_key: ["location_id", "location_tag_id"], force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "location_tag_id", null: false
  end

  create_table "location_tag_maps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logic_rule_definition", force: :cascade do |t|
    t.string "uuid", limit: 38, null: false
    t.string "name", limit: 255, null: false
    t.string "description", limit: 1000
    t.string "rule_content", limit: 2048, null: false
    t.string "language", limit: 255, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.index ["name"], name: "logic_rule_definition_name_key", unique: true
  end

  create_table "logic_rule_token", primary_key: "logic_rule_token_id", force: :cascade do |t|
    t.bigint "creator", null: false
    t.datetime "date_created", default: "0002-11-30 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "token", limit: 512, null: false
    t.string "class_name", limit: 512, null: false
    t.string "state", limit: 512
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "logic_rule_token_uuid_key", unique: true
  end

  create_table "logic_rule_token_tag", id: false, force: :cascade do |t|
    t.integer "logic_rule_token_id", null: false
    t.string "tag", limit: 512, null: false
  end

  create_table "logic_token_registration", primary_key: "token_registration_id", force: :cascade do |t|
    t.bigint "creator", null: false
    t.datetime "date_created", default: "0002-11-30 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "token", limit: 512, null: false
    t.string "provider_class_name", limit: 512, null: false
    t.string "provider_token", limit: 512, null: false
    t.string "configuration", limit: 2000
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "logic_token_registration_uuid_key", unique: true
  end

  create_table "logic_token_registration_tag", id: false, force: :cascade do |t|
    t.integer "token_registration_id", null: false
    t.string "tag", limit: 512, null: false
  end

  create_table "merged_patients", primary_key: "patient_id", id: :bigint, default: nil, force: :cascade do |t|
    t.integer "merged_to_id", null: false
  end

  create_table "mime_type", primary_key: "mime_type_id", force: :cascade do |t|
    t.string "mime_type", limit: 75, default: "", null: false
    t.text "description"
  end

  create_table "moh_other_medications", primary_key: "medication_id", force: :cascade do |t|
    t.integer "drug_inventory_id", null: false
    t.integer "dose_id", null: false
    t.float "min_weight", null: false
    t.float "max_weight", null: false
    t.string "category", limit: 1, null: false
  end

  create_table "moh_regimen_doses", primary_key: "dose_id", force: :cascade do |t|
    t.float "am"
    t.float "pm"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.bigint "creator"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
  end

  create_table "moh_regimen_ingredient", primary_key: "ingredient_id", force: :cascade do |t|
    t.integer "regimen_id"
    t.integer "drug_inventory_id"
    t.integer "dose_id"
    t.float "min_weight"
    t.float "max_weight"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.bigint "creator"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.integer "min_age"
    t.integer "max_age"
    t.string "gender", limit: 255, default: "MF"
  end

  create_table "moh_regimen_ingredient_starter_packs", primary_key: "ingredient_id", force: :cascade do |t|
    t.integer "regimen_id"
    t.integer "drug_inventory_id"
    t.integer "dose_id"
    t.float "min_weight"
    t.float "max_weight"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.bigint "creator"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
  end

  create_table "moh_regimen_ingredient_tb_treatment", id: false, force: :cascade do |t|
    t.integer "ingredient_id", default: 0, null: false
    t.integer "regimen_id"
    t.integer "drug_inventory_id"
    t.integer "dose_id"
    t.float "min_weight"
    t.float "max_weight"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.bigint "creator"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
  end

  create_table "moh_regimen_lookup", primary_key: "regimen_lookup_id", force: :cascade do |t|
    t.integer "num_of_drug_combination"
    t.string "regimen_name", limit: 5, null: false
    t.integer "drug_inventory_id"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.bigint "creator"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
  end

  create_table "moh_regimens", primary_key: "regimen_id", force: :cascade do |t|
    t.integer "regimen_index", null: false
    t.text "description"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.bigint "creator", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
  end

  create_table "national_id", force: :cascade do |t|
    t.string "national_id", limit: 30, default: "", null: false
    t.integer "assigned", limit: 2, default: 0, null: false
    t.integer "eds", limit: 2, default: 0
    t.bigint "creator"
    t.datetime "date_issued"
    t.text "issued_to"
  end

  create_table "national_ids", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "note", primary_key: "note_id", id: :integer, default: 0, force: :cascade do |t|
    t.string "note_type", limit: 50
    t.bigint "patient_id"
    t.bigint "obs_id"
    t.bigint "encounter_id"
    t.text "text", null: false
    t.integer "priority"
    t.integer "parent"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "note_uuid_key", unique: true
  end

  create_table "notification_alert", primary_key: "alert_id", force: :cascade do |t|
    t.string "text", limit: 512, null: false
    t.integer "satisfied_by_any", default: 0, null: false
    t.integer "alert_read", default: 0, null: false
    t.datetime "date_to_expire"
    t.bigint "creator", null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "notification_alert_uuid_key", unique: true
  end

  create_table "notification_alert_recipient", primary_key: ["alert_id", "user_id"], force: :cascade do |t|
    t.integer "alert_id", null: false
    t.bigint "user_id", null: false
    t.integer "alert_read", default: 0, null: false
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
  end

  create_table "notification_template", primary_key: "template_id", force: :cascade do |t|
    t.string "name", limit: 50
    t.text "template"
    t.string "subject", limit: 100
    t.string "sender", limit: 255
    t.string "recipients", limit: 512
    t.integer "ordinal", default: 0
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "notification_template_uuid_key", unique: true
  end

  create_table "notification_tracker", primary_key: "tracker_id", force: :cascade do |t|
    t.string "notification_name", limit: 255, null: false
    t.text "description"
    t.string "notification_response", limit: 255, null: false
    t.datetime "notification_timestamp", null: false
    t.bigint "patient_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "notification_tracker_user_activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "login_timestamp", null: false
    t.text "selected_activities"
  end

  create_table "obs", primary_key: "obs_id", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.integer "concept_id", default: 0, null: false
    t.bigint "encounter_id"
    t.bigint "order_id"
    t.datetime "obs_datetime", default: "1900-01-01 00:00:00", null: false
    t.integer "location_id"
    t.bigint "obs_group_id"
    t.string "accession_number", limit: 255
    t.integer "value_group_id"
    t.integer "value_boolean", limit: 2
    t.integer "value_coded"
    t.integer "value_coded_name_id"
    t.integer "value_drug"
    t.datetime "value_datetime"
    t.float "value_numeric"
    t.string "value_modifier", limit: 2
    t.text "value_text"
    t.datetime "date_started"
    t.datetime "date_stopped"
    t.string "comments", limit: 255
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "value_complex", limit: 255
    t.string "uuid", limit: 38, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["uuid"], name: "obs_uuid_key", unique: true
  end

  create_table "order_extension", primary_key: "order_extension_id", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "value", limit: 50, default: "", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
  end

  create_table "order_type", primary_key: "order_type_id", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.string "description", limit: 255, default: "", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "order_type_uuid_key", unique: true
  end

  create_table "orders", primary_key: "order_id", force: :cascade do |t|
    t.integer "order_type_id", default: 0, null: false
    t.integer "concept_id", default: 0, null: false
    t.bigint "orderer", default: 0
    t.bigint "encounter_id"
    t.text "instructions"
    t.datetime "start_date"
    t.datetime "auto_expire_date"
    t.integer "discontinued", limit: 2, default: 0, null: false
    t.datetime "discontinued_date"
    t.bigint "discontinued_by"
    t.integer "discontinued_reason"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.bigint "patient_id", null: false
    t.string "accession_number", limit: 255
    t.bigint "obs_id"
    t.string "uuid", limit: 38, null: false
    t.string "discontinued_reason_non_coded", limit: 255
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["uuid"], name: "orders_uuid_key", unique: true
  end

  create_table "outpatients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patient", primary_key: "patient_id", force: :cascade do |t|
    t.integer "tribe"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "patient_defaulted_dates", force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "order_id"
    t.integer "drug_id"
    t.float "equivalent_daily_dose"
    t.integer "amount_dispensed"
    t.integer "quantity_given"
    t.date "start_date"
    t.date "end_date"
    t.date "defaulted_date"
    t.date "date_created", default: "2019-04-09"
  end

  create_table "patient_identifier", primary_key: "patient_identifier_id", force: :cascade do |t|
    t.bigint "patient_id", default: 0, null: false
    t.string "identifier", limit: 50, default: "", null: false
    t.integer "identifier_type", default: 0, null: false
    t.integer "preferred", limit: 2, default: 0, null: false
    t.integer "location_id", default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["uuid"], name: "patient_identifier_uuid_key", unique: true
  end

  create_table "patient_identifier_type", primary_key: "patient_identifier_type_id", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50, default: "", null: false
    t.text "description", null: false
    t.string "format", limit: 50
    t.integer "check_digit", limit: 2, default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "required", limit: 2, default: 0, null: false
    t.string "format_description", limit: 255
    t.string "validator", limit: 200
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "patient_identifier_type_uuid_key", unique: true
  end

  create_table "patient_program", primary_key: "patient_program_id", force: :cascade do |t|
    t.bigint "patient_id", default: 0, null: false
    t.integer "program_id", default: 0, null: false
    t.datetime "date_enrolled"
    t.datetime "date_completed"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.integer "location_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["uuid"], name: "patient_program_uuid_key", unique: true
  end

  create_table "patient_state", primary_key: "patient_state_id", force: :cascade do |t|
    t.bigint "patient_program_id", default: 0, null: false
    t.integer "state", default: 0, null: false
    t.date "start_date"
    t.date "end_date"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["uuid"], name: "patient_state_uuid_key", unique: true
  end

  create_table "patientflags_flag", primary_key: "flag_id", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "criteria", limit: 5000, null: false
    t.string "message", limit: 255, null: false
    t.integer "enabled", limit: 2, null: false
    t.string "evaluator", limit: 255, null: false
    t.string "description", limit: 1000
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
  end

  create_table "patientflags_flag_tag", id: false, force: :cascade do |t|
    t.integer "flag_id", null: false
    t.integer "tag_id", null: false
  end

  create_table "patientflags_tag", primary_key: "tag_id", force: :cascade do |t|
    t.string "tag", limit: 255, null: false
    t.string "description", limit: 1000
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
  end

  create_table "patients_for_location", primary_key: "patient_id", id: :bigint, default: nil, force: :cascade do |t|
  end

  create_table "patients_to_merge", id: false, force: :cascade do |t|
    t.bigint "patient_id"
    t.integer "to_merge_to_id"
  end

  create_table "person", primary_key: "person_id", force: :cascade do |t|
    t.string "gender", limit: 50, default: ""
    t.date "birthdate"
    t.integer "birthdate_estimated", limit: 2, default: 0, null: false
    t.integer "dead", limit: 2, default: 0, null: false
    t.datetime "death_date"
    t.integer "cause_of_death"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["uuid"], name: "person_uuid_key", unique: true
  end

  create_table "person_address", primary_key: "person_address_id", force: :cascade do |t|
    t.bigint "person_id"
    t.integer "preferred", limit: 2, default: 0, null: false
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "city_village", limit: 50
    t.string "state_province", limit: 50
    t.string "postal_code", limit: 50
    t.string "country", limit: 50
    t.string "latitude", limit: 50
    t.string "longitude", limit: 50
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "county_district", limit: 50
    t.string "neighborhood_cell", limit: 50
    t.string "region", limit: 50
    t.string "subregion", limit: 50
    t.string "township_division", limit: 50
    t.string "uuid", limit: 38, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["uuid"], name: "person_address_uuid_key", unique: true
  end

  create_table "person_attribute", primary_key: "person_attribute_id", force: :cascade do |t|
    t.bigint "person_id", default: 0, null: false
    t.string "value", limit: 50, default: "", null: false
    t.integer "person_attribute_type_id", default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["uuid"], name: "person_attribute_uuid_key", unique: true
  end

  create_table "person_attribute_type", primary_key: "person_attribute_type_id", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50, default: "", null: false
    t.text "description", null: false
    t.string "format", limit: 50
    t.integer "foreign_key"
    t.integer "searchable", limit: 2, default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "edit_privilege", limit: 255
    t.string "uuid", limit: 38, null: false
    t.float "sort_weight"
    t.index ["uuid"], name: "person_attribute_type_uuid_key", unique: true
  end

  create_table "person_name", primary_key: "person_name_id", force: :cascade do |t|
    t.integer "preferred", limit: 2, default: 0, null: false
    t.bigint "person_id"
    t.string "prefix", limit: 50
    t.string "given_name", limit: 50
    t.string "middle_name", limit: 50
    t.string "family_name_prefix", limit: 50
    t.string "family_name", limit: 50
    t.string "family_name2", limit: 50
    t.string "family_name_suffix", limit: 50
    t.string "degree", limit: 50
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["uuid"], name: "person_name_uuid_key", unique: true
  end

  create_table "person_name_code", primary_key: "person_name_code_id", force: :cascade do |t|
    t.bigint "person_name_id"
    t.string "given_name_code", limit: 50
    t.string "middle_name_code", limit: 50
    t.string "family_name_code", limit: 50
    t.string "family_name2_code", limit: 50
    t.string "family_name_suffix_code", limit: 50
  end

  create_table "pharmacies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pharmacy_batch_item_reallocations", force: :cascade do |t|
    t.string "reallocation_code"
    t.bigint "batch_item_id"
    t.float "quantity"
    t.integer "location_id"
    t.datetime "date_created"
    t.bigint "creator"
    t.boolean "voided"
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.bigint "changed_by"
    t.datetime "date_changed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pharmacy_batch_items", force: :cascade do |t|
    t.bigint "pharmacy_batch_id"
    t.integer "drug_id"
    t.float "delivered_quantity"
    t.float "current_quantity"
    t.date "delivery_date"
    t.date "expiry_date"
    t.bigint "creator", null: false
    t.datetime "date_created", default: -> { "now()" }, null: false
    t.datetime "date_changed", default: -> { "now()" }
    t.boolean "voided"
    t.bigint "voided_by"
    t.string "void_reason"
    t.datetime "date_voided"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pharmacy_batches", force: :cascade do |t|
    t.string "batch_number"
    t.bigint "creator", null: false
    t.datetime "date_created", default: -> { "now()" }, null: false
    t.datetime "date_changed"
    t.boolean "voided"
    t.bigint "voided_by"
    t.string "void_reason"
    t.datetime "date_voided"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pharmacy_encounter_type", primary_key: "pharmacy_encounter_type_id", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "description", null: false
    t.string "format", limit: 50
    t.integer "foreign_key"
    t.integer "searchable", limit: 2
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 225
  end

  create_table "pharmacy_obs", primary_key: "pharmacy_module_id", force: :cascade do |t|
    t.integer "pharmacy_encounter_type", default: 0, null: false
    t.integer "drug_id", default: 0, null: false
    t.float "value_numeric"
    t.float "expiring_units"
    t.integer "pack_size"
    t.integer "value_coded"
    t.string "value_text", limit: 15
    t.date "expiry_date"
    t.date "encounter_date", default: "1900-01-01", null: false
    t.bigint "creator", null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 225
    t.bigint "batch_item_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "privilege", primary_key: "privilege", id: :string, limit: 50, default: "", force: :cascade do |t|
    t.string "description", limit: 250, default: "", null: false
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "privilege_uuid_key", unique: true
  end

  create_table "program", primary_key: "program_id", id: :serial, force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.string "name", limit: 50, null: false
    t.string "description", limit: 500
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "program_uuid_key", unique: true
  end

  create_table "program_encounter", primary_key: "program_encounter_id", force: :cascade do |t|
    t.bigint "patient_id"
    t.datetime "date_time"
    t.integer "program_id"
  end

  create_table "program_encounter_details", force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "program_encounter_id"
    t.integer "program_id"
    t.integer "voided", default: 0
  end

  create_table "program_encounter_type_map", primary_key: "program_encounter_type_map_id", force: :cascade do |t|
    t.integer "program_id"
    t.integer "encounter_type_id"
  end

  create_table "program_location_restriction", primary_key: "program_location_restriction_id", force: :cascade do |t|
    t.integer "program_id"
    t.integer "location_id"
  end

  create_table "program_orders_map", primary_key: "program_orders_map_id", force: :cascade do |t|
    t.integer "program_id"
    t.integer "concept_id"
  end

  create_table "program_patient_identifier_type_map", primary_key: "program_patient_identifier_type_map_id", force: :cascade do |t|
    t.integer "program_id"
    t.integer "patient_identifier_type_id"
  end

  create_table "program_relationship_type_map", primary_key: "program_relationship_type_map_id", force: :cascade do |t|
    t.integer "program_id"
    t.integer "relationship_type_id"
  end

  create_table "program_workflow", primary_key: "program_workflow_id", id: :serial, force: :cascade do |t|
    t.integer "program_id", default: 0, null: false
    t.integer "concept_id", default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "program_workflow_uuid_key", unique: true
  end

  create_table "program_workflow_state", primary_key: "program_workflow_state_id", id: :serial, force: :cascade do |t|
    t.integer "program_workflow_id", default: 0, null: false
    t.integer "concept_id", default: 0, null: false
    t.integer "initial", limit: 2, default: 0, null: false
    t.integer "terminal", limit: 2, default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "program_workflow_state_uuid_key", unique: true
  end

  create_table "regimen", primary_key: "regimen_id", force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.string "regimen_index", limit: 5
    t.float "min_weight", default: 0.0, null: false
    t.float "max_weight", default: 200.0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.integer "program_id", default: 0, null: false
  end

  create_table "regimen_drug_order", primary_key: "regimen_drug_order_id", force: :cascade do |t|
    t.integer "regimen_id", default: 0, null: false
    t.integer "drug_inventory_id", default: 0
    t.float "dose"
    t.float "equivalent_daily_dose"
    t.string "units", limit: 255
    t.string "frequency", limit: 255
    t.integer "prn", limit: 2, default: 0, null: false
    t.integer "complex", limit: 2, default: 0, null: false
    t.integer "quantity"
    t.text "instructions"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "regimen_drug_order_uuid_key", unique: true
  end

  create_table "region", primary_key: "region_id", force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
  end

  create_table "regions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationship", primary_key: "relationship_id", force: :cascade do |t|
    t.bigint "person_a", null: false
    t.integer "relationship", default: 0, null: false
    t.bigint "person_b", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["uuid"], name: "relationship_uuid_key", unique: true
  end

  create_table "relationship_type", primary_key: "relationship_type_id", id: :serial, force: :cascade do |t|
    t.string "a_is_to_b", limit: 50, null: false
    t.string "b_is_to_a", limit: 50, null: false
    t.integer "preferred", default: 0, null: false
    t.integer "weight", default: 0, null: false
    t.string "description", limit: 255, default: "", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1000-01-01 00:00:00", null: false
    t.string "uuid", limit: 38, null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.index ["uuid"], name: "relationship_type_uuid_key", unique: true
  end

  create_table "report_def", primary_key: "report_def_id", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "creator", default: 0, null: false
  end

  create_table "report_object", primary_key: "report_object_id", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "description", limit: 1000
    t.string "report_object_type", limit: 255, null: false
    t.string "report_object_sub_type", limit: 255, null: false
    t.text "xml_data"
    t.bigint "creator", null: false
    t.datetime "date_created", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "report_object_uuid_key", unique: true
  end

  create_table "report_schema_xml", primary_key: "report_schema_id", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.text "description", null: false
    t.text "xml_data", null: false
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "report_schema_xml_uuid_key", unique: true
  end

  create_table "reporting_report_design", force: :cascade do |t|
    t.string "uuid", limit: 38, null: false
    t.string "name", limit: 255, null: false
    t.string "description", limit: 1000
    t.integer "report_definition_id", default: 0, null: false
    t.string "renderer_type", limit: 255, null: false
    t.text "properties"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.date "start_date"
    t.date "end_date"
  end

  create_table "reporting_report_design_resource", force: :cascade do |t|
    t.string "uuid", limit: 38, null: false
    t.string "name", limit: 255, null: false
    t.string "description", limit: 1000
    t.integer "report_design_id", default: 0, null: false
    t.string "content_type", limit: 50
    t.string "extension", limit: 20
    t.binary "contents"
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "indicator_name", limit: 255
    t.string "indicator_short_name", limit: 255
  end

  create_table "role", primary_key: "role", id: :string, limit: 50, default: "", force: :cascade do |t|
    t.string "description", limit: 255, default: "", null: false
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "role_uuid_key", unique: true
  end

  create_table "role_privilege", primary_key: ["privilege", "role"], force: :cascade do |t|
    t.string "role", limit: 50, default: "", null: false
    t.string "privilege", limit: 50, default: "", null: false
  end

  create_table "role_role", primary_key: ["parent_role", "child_role"], force: :cascade do |t|
    t.string "parent_role", limit: 50, default: "", null: false
    t.string "child_role", limit: 255, default: "", null: false
  end

  create_table "scheduler_task_config", primary_key: "task_config_id", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "description", limit: 1024
    t.text "schedulable_class"
    t.datetime "start_time"
    t.string "start_time_pattern", limit: 50
    t.integer "repeat_interval", default: 0, null: false
    t.integer "start_on_startup", default: 0, null: false
    t.integer "started", default: 0, null: false
    t.bigint "created_by", default: 0
    t.datetime "date_created", default: "2005-01-01 00:00:00"
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
    t.datetime "last_execution_time"
    t.index ["uuid"], name: "scheduler_task_config_uuid_key", unique: true
  end

  create_table "scheduler_task_config_property", primary_key: "task_config_property_id", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.text "value"
    t.integer "task_config_id"
  end

  create_table "schema_info", id: false, force: :cascade do |t|
    t.integer "version"
  end

  create_table "send_results_to_couchdbs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "serialized_object", primary_key: "serialized_object_id", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "description", limit: 5000
    t.string "type", limit: 255, null: false
    t.string "subtype", limit: 255, null: false
    t.string "serialization_class", limit: 255, null: false
    t.text "serialized_data", null: false
    t.datetime "date_created", null: false
    t.bigint "creator", null: false
    t.datetime "date_changed"
    t.bigint "changed_by"
    t.integer "retired", limit: 2, default: 0, null: false
    t.datetime "date_retired"
    t.bigint "retired_by"
    t.string "retire_reason", limit: 1000
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "serialized_object_uuid_key", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", limit: 255
    t.text "data"
    t.datetime "updated_at"
  end

  create_table "task", primary_key: "task_id", force: :cascade do |t|
    t.string "url", limit: 255
    t.string "encounter_type", limit: 255
    t.text "description"
    t.string "location", limit: 255
    t.string "gender", limit: 50
    t.integer "has_obs_concept_id"
    t.integer "has_obs_value_coded"
    t.integer "has_obs_value_drug"
    t.datetime "has_obs_value_timestamp"
    t.float "has_obs_value_numeric"
    t.text "has_obs_value_text"
    t.integer "has_program_id"
    t.integer "has_program_workflow_state_id"
    t.integer "has_identifier_type_id"
    t.integer "has_relationship_type_id"
    t.integer "has_order_type_id"
    t.integer "skip_if_has", limit: 2, default: 0
    t.float "sort_weight"
    t.bigint "creator", null: false
    t.datetime "date_created", null: false
    t.integer "voided", limit: 2, default: 0
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38
  end

  create_table "traditional_authorities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traditional_authority", primary_key: "traditional_authority_id", force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.integer "district_id", default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
  end

  create_table "tribe", primary_key: "tribe_id", force: :cascade do |t|
    t.integer "retired", limit: 2, default: 0, null: false
    t.string "name", limit: 50, default: "", null: false
  end

  create_table "user_property", primary_key: ["user_id", "property"], force: :cascade do |t|
    t.bigint "user_id", default: 0, null: false
    t.string "property", limit: 100, default: "", null: false
    t.string "property_value", limit: 255, default: "", null: false
  end

  create_table "user_role", primary_key: ["role", "user_id"], force: :cascade do |t|
    t.bigint "user_id", default: 0, null: false
    t.string "role", limit: 50, default: "", null: false
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.string "system_id", limit: 50, default: "", null: false
    t.string "username", limit: 50
    t.string "password", limit: 128
    t.string "salt", limit: 128
    t.string "secret_question", limit: 255
    t.string "secret_answer", limit: 255
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.bigint "person_id"
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.string "authentication_token", limit: 255
    t.date "token_expiry_time"
    t.datetime "deactivated_on"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "uuid_remaps", force: :cascade do |t|
    t.string "record_type"
    t.bigint "record_id"
    t.string "old_uuid", limit: 255
    t.string "new_uuid", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "validation_results", force: :cascade do |t|
    t.integer "rule_id"
    t.integer "failures"
    t.date "date_checked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "validation_rules", force: :cascade do |t|
    t.string "expr", limit: 255
    t.text "desc1"
    t.integer "type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "village", primary_key: "village_id", force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.integer "traditional_authority_id", default: 0, null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.bigint "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 255
  end

  create_table "villages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weight_for_height", id: false, force: :cascade do |t|
    t.float "supinecm"
    t.float "medianwtht"
    t.float "sdlowwtht"
    t.float "sdhighwtht"
    t.integer "sex", limit: 2
    t.string "heightsex", limit: 5
  end

  create_table "weight_for_heights", force: :cascade do |t|
    t.float "supine_cm"
    t.float "median_weight_height"
    t.float "standard_low_weight_height"
    t.float "standard_high_weight_height"
    t.integer "sex"
  end

  create_table "weight_height_for_age", id: false, force: :cascade do |t|
    t.integer "agemths", limit: 2
    t.integer "sex", limit: 2
    t.float "medianht"
    t.float "sdlowht"
    t.float "sdhighht"
    t.float "medianwt"
    t.float "sdlowwt"
    t.float "sdhighwt"
    t.string "agesex", limit: 4
  end

  create_table "weight_height_for_ages", id: false, force: :cascade do |t|
    t.integer "age_in_months", limit: 2
    t.string "sex", limit: 12
    t.float "median_height"
    t.float "standard_low_height"
    t.float "standard_high_height"
    t.float "median_weight"
    t.float "standard_low_weight"
    t.float "standard_high_weight"
    t.string "age_sex", limit: 4
  end

end
