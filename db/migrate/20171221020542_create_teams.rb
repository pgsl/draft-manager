class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.references :division, foreign_key: true
      t.string :team_name
      t.string :coach_name
      t.timestamps
    end
  end
end
