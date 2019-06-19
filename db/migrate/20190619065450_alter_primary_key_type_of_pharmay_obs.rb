class AlterPrimaryKeyTypeOfPharmayObs < ActiveRecord::Migration[5.2]
  def up
    execute <<~SQL
      ALTER TABLE pharmacy_obs
        MODIFY COLUMN pharmacy_module_id INT NOT NULL
    SQL

    execute <<~SQL
      ALTER TABLE pharmacy_obs
        DROP PRIMARY KEY,
        MODIFY COLUMN pharmacy_module_id BIGINT NOT NULL PRIMARY KEY
    SQL
  end

  def down
    execute <<~SQL
      ALTER TABLE pharmacy_obs
        DROP PRIMARY KEY,
        MODIFY COLUMN pharmacy_module_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    SQL
  end
end
