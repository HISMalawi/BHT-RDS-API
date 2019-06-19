class AddTimestampsToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :person, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
    add_column :person, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
  end
end
