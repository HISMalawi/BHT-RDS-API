# frozen_string_literal: true

# Reads IDS patient details from an OpenMRS patient.
#
# Example:
#   >>> reader = IdsService::PatientDetailsReader.new(Patient.first)
#   >>> ids_patient_details = reader.read
#   >>> ids_patient_details.save # Saves details to IDS database
class IdsService::PatientDetailsReader
  attr_reader :patient

  def initialize(patient)
    @patient = patient
  end

  # Read patient details into an Ids::PatientDetails model
  def read
    details = Ids::PatientDetails.new

    read_name(details)
    read_birth_date(details)
    read_gender(details)
    read_address(details)
    read_occupation(details)
    read_contact_details(details)

    details
  end

  private

  # Reads patient birthdate into Ids::PatientDetails object, `details`.
  def read_birth_date(details)
    details.birthdate = patient.person.birthdate
    details.birthdate_estimated = patient.person.birthdate_estimated
  end

  def read_gender(details)
    details.gender = patient.person.gender
  end

  # Reads patient name into Ids::PatientDetails object, `details`.
  def read_name(details)
    name = patient.person.names.first

    details.given_name = name.given_name
    details.family_name = name.family_name
    details.middle_name = name.middle_name
    details.maiden_name = name.family_name2
  end

  # Reads patient address into Ids::PatientDetails object, `details`.
  def read_address(details)
    rds_address = patient.person.addresses.first

    details.country_of_origin = rds_address.country
    details.home_district = rds_address.address2
    details.home_ta = rds_address.county_district
    details.home_village = rds_address.neighborhood_cell

    address.current_district = rds_address.state_province
    address.current_ta = rds_address.township_division
    address.current_village = rds_address.city_village

    details.current_address = address
  end

  # Read patient occupation into Ids::PatientDetails object, `details`.
  def read_occupation(details)
    attribute_type = PersonAttributeType.find_by_name('Occupation')
    occupation = patient.person.attributes.where(type: attribute_type)\
                        .order(:date_created).last&.value
    details.occupation = occupation
  end

  # Read patient phone numbers into Ids::PatientDetails object, `details`.
  def read_contact_details(details)
    phone_number_types = [PersonAttributeType.find_by_name('Home Phone Number'),
                          PersonAttributeType.find_by_name('Cell Phone Number')]

    contact_details = ContactDetails.new

    PersonAttribute.where(person_id: patient.id,
                          type: phone_number_types).each do |attr|
      case attr.id
      when phone_number_types[0].id # Home phone number
        contact_details.home_phone_number = attr.value
      when phone_number_types[1].id # Cell phone number
        contact_details.cell_phone_number = attr.value
      end
    end

    details.contact_details = contact_details
  end
end
