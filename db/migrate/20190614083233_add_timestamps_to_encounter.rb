class AddTimestampsToEncounter < ActiveRecord::Migration[5.2]
  def change
    add_column :encounter, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
    add_column :encounter, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
  end
end
