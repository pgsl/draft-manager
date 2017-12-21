require 'csv'

class Team < ApplicationRecord

  include Importable

  belongs_to :division
  has_many :players
  has_many :auto_draft_players, foreign_key: 'auto_draft_team_id', class_name: 'Player'

  validates :team_name, presence: true, uniqueness: { scope: :division_id }
  validates :coach_name, presence: true

  def self.import_csv(division, file)
    Team.transaction do
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        team = Team.new(division: division)
        team.team_name  = row["Team Name"]
        team.coach_name = row["Coach Name"]
        team.save!
      end
    end
  end

end
