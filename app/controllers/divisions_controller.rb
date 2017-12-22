class DivisionsController < ApplicationController

  before_action :load_objects

  def index
    division = Division.create name: "(set name)"
    redirect_to d_path(id: division)
  end

  def show
    if @division
      @players = @division.players.order(:last_name)
      @teams = @division.teams.order(:team_name)
    else
      redirect_to root_path
    end
  end

  def update
    player = @division.players.find(params[:player_id])
    team = @division.teams.find(params[:team_id])
    @division.draft_player(player, team)
    redirect_to draft_d_path(id: @division)
  end

  def delete
    @division.undo_last_drafted_player!
    redirect_to draft_d_path(id: @division)
  end

  def draft
    @division.calculate_draft_order
    @players = @division.players
    @teams = @division.teams.order(:draft_position)
  end

  private

  def load_objects
    @division = Division.find_by(uuid: params[:id]) if params[:id]
  end

end
