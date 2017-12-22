class AddDraftFields < ActiveRecord::Migration[5.1]
  def change
    rename_column :players, :skill_1, :pitching
    rename_column :players, :skill_2, :catching
    rename_column :players, :skill_3, :overall
    add_column :players, :draft_order, :integer

    add_column :teams, :draft_position, :integer

    add_column :divisions, :draft_window, :integer, default: 6
    add_column :divisions, :draft_team_sort, :integer, default: 0

    remove_column :divisions, :skills
  end
end
