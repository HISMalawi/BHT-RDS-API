class AddTimestampsToPersonAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :person_address, :created_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
    add_column :person_address, :updated_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
  end
end
