class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.references :division, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.references :team, foreign_key: true
      t.references :auto_draft_team, foreign_key: { to_table: :teams }
      t.integer :skill_1
      t.integer :skill_2
      t.integer :skill_3

      t.timestamps
    end
  end
end
