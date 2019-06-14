class AddTimestampsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
    add_column :users, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
  end
end
