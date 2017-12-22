require 'csv'

class PlayersController < ApplicationController

  before_action :load_objects

  def index
    csv_data = CSV.generate do |csv|
      header = ["First Name", "Last Name", "Team", "Auto Draft Team", "Pitching", "Catching", "Overall"]
      csv << header
      @division.players.each do |player|
        row = []
        row << player.first_name
        row << player.last_name
        row << player.team.try(:team_name)
        row << player.auto_draft_team.try(:team_name)
        row << player.pitching
        row << player.catching
        row << player.overall
        csv << row
      end
    end
    send_data csv_data, filename: "players-#{@division.to_param}.csv"
  end

  def create
    if params[:file]
      begin
        Player.transaction do
          @division.players.destroy_all
          Player.import_csv(@division, params[:file])
        end
      rescue => e
        logger.debug(e.message)
        flash[:alert] = "There are errors in the uploaded file it cannot be processed."
      end
    end
    redirect_to d_path(id: @division)
  end

  private

  def load_objects
    @division = Division.find_by(uuid: params[:d_id]) if params[:d_id]
  end

end
