# frozen_string_literal: true

module Ids::ConceptModelMap
  class << self
    include ModelUtils
  end

  @concept_model_map = {
    # Map (obs) concept_id to target tables in IDS
    # ie  concept_id: model
    concept('ADHERENCE').concept_id => {
      model_class: Ids::MedicationAdherence,
      model_fields: %i[value_modifier value_numeric value_drug]
    },
    concept('Height (cm)').concept_id => {
      model_class: Ids::Vitals,
      model_fields: %i[value_modifier value_numeric]
    },
    concept('Weight (km)').concept_id => {
      model_class: Ids::Vitals,
      model_fields: %i[value_modifier value_numeric]
    },
    concept('Systolic blood pressure').concept_id => {
      model_class: Ids::Vitals,
      model_fields: %i[value_modifier value_numeric]
    },
    concept('Diastolic blood pressure').concept_id => {
      model_class: Ids::Vitals,
      model_fields: %i[value_modifier value_numeric]
    },
    concept('Breastfeeding?').concept_id => {
      model_class: Ids::BreastfeedingStatus,
      model_fields: %i[value_coded]
    },
    concept('Method of family planning').concept_id => Ids::FamilyPlanning,
    concept('Who stages criteria present').concept_id => {
      model_class: Ids::Diagnosis,
      model_fields: { value_  
      }
    },
    concept('Amount dispensed').concept_id => Ids::MedicationDispensation,
    concept('Symptom present').concept_id => Ids::Symptom
  }
end
