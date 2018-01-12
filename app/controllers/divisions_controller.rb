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
    if params[:draft_team_sort]
      @division.draft_team_sort = params[:draft_team_sort]
      @division.save!
      if @division.end_draft?
        redirect_to d_path(id: @division)
      else
        redirect_to draft_d_path(id: @division)
      end
    elsif params[:draft_window]
      @division.draft_window = params[:draft_window]
      @division.save!
      redirect_to draft_d_path(id: @division)
    else
      player = @division.players.find(params[:player_id])
      team = @division.teams.find(params[:team_id])
      @division.draft_player(player, team)
      redirect_to draft_d_path(id: @division)
    end
  end

  def destroy
    @division.undo_last_drafted_player!
    redirect_to draft_d_path(id: @division)
  end

  def draft
    @division.calculate_draft_order
    @players = @division.players.undrafted.sorted_by_skill(@division.draft_team_sort)
    @teams = @division.teams.order(:draft_position)
    @pass_amount = params[:pass].to_i
    if @pass_amount != 0 && @teams.size > @pass_amount
      @draft_team = @teams[@pass_amount]
    else
      @pass_amount = 0
      @draft_team = @teams.first
    end
    @draft_window = @division.draft_window_size
    @auto_draft = Player.where(id: @players.limit(@draft_window).pluck(:id)).where("players.auto_draft_team_id IS NOT NULL").exists?
  end

  private

  def load_objects
    @division = Division.find_by(uuid: params[:id]) if params[:id]
  end

end
