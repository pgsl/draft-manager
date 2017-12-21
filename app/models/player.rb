class Player < ApplicationRecord

  include Importable

  belongs_to :division
  belongs_to :team, optional: true
  belongs_to :auto_draft_team, class_name: 'Team', optional: true

  def name
    "#{first_name} #{last_name}"
  end

  def skills
    [skill_1, skill_2, skill_3]
  end

  def self.import_csv(division, file)
    Player.transaction do
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        player = Player.new(division: division)
        player.first_name      = row["First Name"]
        player.last_name       = row["Last Name"]
        player.team            = division.teams.find_by(team_name: row["Team"])
        player.auto_draft_team = division.teams.find_by(team_name: row["Auto Draft Team"])
        player.skill_1         = row["Skill 1"].to_i
        player.skill_2         = row["Skill 2"].to_i
        player.skill_3         = row["Skill 3"].to_i
        player.save!
      end
    end
  end

end
