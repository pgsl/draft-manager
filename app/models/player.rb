class Player < ApplicationRecord

  include Importable

  belongs_to :division
  belongs_to :team, optional: true
  belongs_to :auto_draft_team, class_name: 'Team', optional: true

  scope :undrafted, ->{ where("players.team_id IS NULL") }

  validates :first_name, presence: true
  validates :last_name, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def best_skill
    [pitching, catching, overall].max
  end

  def skill_by_name(skill_name)
    return pitching if skill_name == "pitching"
    return catching if skill_name == "catching"
    return overall if skill_name == "overall"
    raise "Unknown skill"
  end

  def self.with_skill(draft_round)
    case draft_round.to_sym
    when :pitching_round_1, :pitching_round_2
      where("players.pitching!=0")
    when :catching_round_1, :catching_round_2
      where("players.catching!=0")
    when :overall, :overall_open, :end_draft
      where("players.overall!=0")
    else
      raise "Unknown draft round"
    end
  end

  def self.sorted_by_skill(draft_round)
    case draft_round.to_sym
    when :pitching_round_1, :pitching_round_2
      order("players.pitching DESC")
    when :catching_round_1, :catching_round_2
      order("players.catching DESC")
    when :overall, :overall_open, :end_draft
      order("players.overall DESC")
    else
      raise "Unknown draft round"
    end
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
        player.pitching        = row["Pitching"].to_i
        player.catching        = row["Catching"].to_i
        player.overall         = row["Overall"].to_i
        player.save!
      end
    end
  end

end
