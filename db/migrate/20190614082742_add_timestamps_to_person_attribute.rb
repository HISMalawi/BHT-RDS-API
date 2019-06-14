class AddTimestampsToPersonAttribute < ActiveRecord::Migration[5.2]
  def change
    add_column :person_attribute, :created_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
    add_column :person_attribute, :updated_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
  end
end
