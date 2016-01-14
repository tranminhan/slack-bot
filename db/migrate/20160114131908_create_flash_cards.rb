class CreateFlashCards < ActiveRecord::Migration
  def change
    create_table :flash_cards do |t|
      t.string :term
      t.string :definition

      t.timestamps null: false
    end
  end
end
