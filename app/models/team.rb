require 'csv'

class Team < ApplicationRecord

  include Importable

  belongs_to :division
  has_many :players
  has_many :auto_draft_players, foreign_key: 'auto_draft_team_id', class_name: 'Player'

  validates :team_name, presence: true, uniqueness: { scope: :division_id }
  validates :coach_name, presence: true

  # Determine the score for the team based on the selector.  Selector can be best_auto_draft_score
  def score(draft_round)
    case draft_round.to_sym
    when :pitching_round_1
      auto_draft_players.order("(greatest(pitching, catching, overall) + rand()) DESC").first.best_skill + (100000 * players.count)
    when :pitching_round_2
      players.sum(:pitching)
    when :catching_round_1, :catching_round_2
      players.sum("greatest(pitching, catching)")
    when :overall, :overall_open, :end_draft
      players.sum("greatest(pitching, catching, overall)")
    else
      raise "Unknown draft round"
    end
  end

  def display_name
    "#{team_name}: #{coach_name}"
  end

  def display_score(draft_round)
    case draft_round.to_sym
    when :pitching_round_1
      "n/a"
    when :pitching_round_2
      players.sum(:pitching)
    when :catching_round_1, :catching_round_2
      players.sum("greatest(pitching, catching)")
    when :overall, :overall_open, :end_draft
      players.sum("greatest(pitching, catching, overall)")
    else
      raise "Unknown draft round"
    end
  end

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
