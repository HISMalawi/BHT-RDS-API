class AddObsIdToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :obs_id, :integer
  end
end
