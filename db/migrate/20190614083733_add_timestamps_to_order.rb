class AddTimestampsToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
    add_column :orders, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
  end
end
