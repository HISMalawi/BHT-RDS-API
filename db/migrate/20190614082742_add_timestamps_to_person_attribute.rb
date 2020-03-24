class AddTimestampsToPersonAttribute < ActiveRecord::Migration[5.2]
  def change
    add_column :person_attribute, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :person_attribute, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
