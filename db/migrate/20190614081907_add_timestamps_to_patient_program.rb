class AddTimestampsToPatientProgram < ActiveRecord::Migration[5.2]
  def change
    add_column :patient_program, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :patient_program, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
