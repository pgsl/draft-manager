class CreateDivisions < ActiveRecord::Migration[5.1]
  def change
    create_table :divisions do |t|
      t.string :uuid
      t.string :name
      t.string :skills

      t.timestamps
    end
  end
end
