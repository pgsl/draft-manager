class Division < ApplicationRecord

  enum draft_team_sort: [:pitching_round_1, :pitching_round_2, :catching_round_1, :catching_round_2, :overall, :overall_open, :end_draft]

  has_many :teams, dependent: :destroy
  has_many :players, dependent: :destroy

  after_initialize :set_defaults

  def set_defaults
    self[:uuid] ||= generate_token(:uuid)
  end

  def to_param
    self.uuid
  end

  def calculate_draft_order
    selector = draft_team_sort
    teams.sort { |a,b| a.score(selector) <=> b.score(selector) }.each_with_index do |team, index|
      team.draft_position = index
      team.save!
    end
  end

  def draft_window_size
    case draft_team_sort.to_sym
    when :pitching_round_1, :pitching_round_2
      skill = "pitching"
    when :catching_round_1,:catching_round_2
      skill = "catching"
    when :overall, :overall_open, :end_draft
      skill = "overall"
    else
      raise "Unknown draft round"
    end
    draft_window_players = players.undrafted.sorted_by_skill(draft_team_sort).with_skill(draft_team_sort).limit(draft_window)
    if overall_open?
      # Return all eligible players (players without a zero score)
      return players.undrafted.sorted_by_skill(draft_team_sort).with_skill(draft_team_sort).count
    else
      offset = 0
      if last_player = draft_window_players.last
        skill_query = players.undrafted.where("#{skill}=?", last_player.skill_by_name(skill))
        offset = skill_query.where("players.id NOT IN (?)", draft_window_players.pluck(:id)).count
      end
      draft_window_players.size + offset
    end
  end

  # Draft the player to the team and calculate the draft order.
  def draft_player(player, team)
    player.team = team
    player.draft_order = (players.maximum(:draft_order) || 0) + 1
    player.save!
  end

  # Remove the last drafted player from the team and calculate the draft order.
  def undo_last_drafted_player!
    player = players.order("draft_order DESC").first
    if player
      player.team = nil
      player.draft_order = nil
      player.save!
    end
  end

end
