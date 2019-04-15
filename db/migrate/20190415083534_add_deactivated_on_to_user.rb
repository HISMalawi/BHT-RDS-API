class AddDeactivatedOnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :deactivated_on, :date, default: nil, null: true
  end
end
