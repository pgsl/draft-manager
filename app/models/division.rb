class Division < ApplicationRecord

  enum draft_team_sort: [:pitching_round_1, :pitching_round_2, :catching_round_1, :catching_round_2, :overall, :overall_open]
  # enum draft_player_sort: [:pitching, :catching, :overall]

  has_many :teams, dependent: :destroy
  has_many :players, dependent: :destroy

  after_initialize :set_defaults

  def set_defaults
    self[:uuid]         ||= generate_token(:uuid)
    self[:draft_window] ||= 6
  end

  def to_param
    self.uuid
  end

  def calculate_draft_order
    selector = draft_team_sort.to_sym
    teams.sort { |a,b| a.score(selector) <=> b.score(selector) }.each_with_index do |team, index|
      team.draft_position = index
      team.save!
    end
  end

  # Draft the player to the team and calculate the draft order.
  def draft_player(player, team)
    player.team = team
    player.draft_order = (players.maximum(:draft_order) || 0) + 1
    player.save!
    calculate_draft_order
  end

  # Remove the last drafted player from the team and calculate the draft order.
  def undo_last_drafted_player!
    player = players.order("draft_order DESC").first
    if player
      player.team = nil
      player.draft_order = nil
      player.save!
    end
    calculate_draft_order
  end

end
