# frozen_string_literal: true

# Reads OpenMRS patient observations into IDS observations
#
# Example:
#   >>> reader = IdsService::ObservationsReader.new(patient, IdsService::ConceptModelMap.instance)
#   >>> reader.observations.each do |observation|
#   >>>   # Expect observation to be one of IDS' observation classes.
class IdsService::ObservationsReader
  attr_reader :patient, :concept_model_map

  OBS_MODEL_VALUE_READERS = %i[value_coded value_datetime value_text
                               value_numeric value_group_id value_drug
                               value_modifier].freeze

  def initialize(patient, concept_model_map)
    @patient = patient
    @concept_model_map = concept_model_map
  end

  def observations
    Enumerator.new do |enum|
      patient.observations.each do |openmrs_obs|
        ids_model = concept_model_map[openmrs_obs.concept_id]

        ids_obs = ids_model.new

        ids_obs.concept_id = openmrs_obs.concept_id
        ids_obs.obs_datetime = openmrs_obs.obs_datetime
        ids_obs.person_id = openmrs_obs.person_id

        read_values(ids_obs, openmrs_obs)
        enum.yield(ids_obs)
      end
    end
  end

  # Read OpenMRS (RDS) obs values into IDS obs.
  def read_values(ids_obs, openmrs_obs)
    OBS_MODEL_VALUE_READERS.each do |reader|
      writer = "#{reader}=".to_sym

      next unless ids_obs.respond_to?(writer) && openmrs_obs.respond_to?(reader)

      # Set ids_obs field to value from corresponding openmrs obs field
      ids_obs.send(writer, openmrs_obs.send(reader))
    end
  end
end
