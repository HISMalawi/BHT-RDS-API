class CreateUuidRemaps < ActiveRecord::Migration[5.2]
  def change
    create_table :uuid_remaps do |t|
      t.string :record_type
      t.bigint :record_id
      t.string :old_uuid, limit: 255
      t.string :new_uuid, limit: 255

      t.timestamps
    end
  end
end
