class AddTimestampsToPatientState < ActiveRecord::Migration[5.2]
  def change
    add_column :patient_state, :created_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
    add_column :patient_state, :updated_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
  end
end
