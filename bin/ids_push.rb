# frozen_string_literal: true

require 'ostruct'

class << self
  include ModelUtils
end

IDS_CONCEPT_MODEL_MAP = {
  # Map (obs) concept_id to target tables in IDS
  # ie  concept_id: model
  concept('ADHERENCE').concept_id => Ids::MedicationAdherence
}

def batch_query(query_generator, batch_size: QUERY_BATCH_SIZE)
  Enumerator.new do |enumerator|
    offset = 0

    loop do
      records = query_generator.call.offset(offset).limit(batch_size)
      records.each { |record| enumerator.yield(record) }

      break if records.empty?
    end
  end
end

def patients
  batch_query(-> { Patient.where() }, batch_size: QUERY_BATCH_SIZE)
end

def process_patients
  patients.each do
    patient_details_service.read_details_from_patient(patient).save
  end
end

