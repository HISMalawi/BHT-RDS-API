class AddProgramIdToEncounter < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :encounter, :program, primary_key: :program_id
  end
end
