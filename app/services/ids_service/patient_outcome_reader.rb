# frozen_string_literal: true

class Ids::PatientOutcomeReader
  attr_reader :patient

  OUTCOME_READER_CLASSES = {
    'HIV PROGRAM' => Ids::PatientOutcomeReader::HivProgramReader
  }.freeze

  def initialize(patient)
    @patient = patient
  end

  def read
    patient.programs.each do |program|
      reader = reader_strategy(program)
      next unless reader

      outcome_struct = reader.(patient)
      create_outcome(patient, outcome_struct)
    end
  end

  private

  def reader_strategy(program)
    reader_class = OUTCOME_READER_CLASSES[program.name.upcase]
    unless reader_class
      LOGGER.warn("No reader for program `#{program.name.upcase}` found")
      return nil
    end

    ->(patient) { reader_class.read(patient) }
  end

  def create_outcome(patient, outcome_struct)
    outcome_encounter = find_outcome_encounter(patient, outcome_struct.start_date)
    Ids::Outcome.new(encounter: outcome_encounter,
                     concept: outcome_concept,
                     outcome_date: outcome_struct.start_date,
                     outcome_reason: outcome_struct.reason,
                     outcome_source: outcome_struct.source)
  end
end
