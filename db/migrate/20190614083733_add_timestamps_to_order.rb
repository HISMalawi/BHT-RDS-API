class AddTimestampsToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :created_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
    add_column :orders, :updated_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
  end
end
