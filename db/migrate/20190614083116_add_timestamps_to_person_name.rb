class AddTimestampsToPersonName < ActiveRecord::Migration[5.2]
  def change
    add_column :person_name, :created_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
    add_column :person_name, :updated_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
  end
end
