class AddTimestampsToEncounter < ActiveRecord::Migration[5.2]
  def change
    add_column :encounter, :created_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
    add_column :encounter, :updated_at, :datetime, null: false, options: -> { 'DEFAULT NOWI()' }
  end
end
