class CreateCouchUpdates < ActiveRecord::Migration[5.2]
  def change
    create_table :couch_updates do |t|
      t.string :doc_id, null: false
      t.string :doc_type, null: false
      t.text :doc, null: false

      t.timestamps
    end
  end
end
