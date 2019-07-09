class AddTimestampsToRelationship < ActiveRecord::Migration[5.2]
  def change
    add_column :relationship, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
    add_column :relationship, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
  end
end
