class TeamsController < ApplicationController

  def create
    @division = Division.find_by(uuid: params[:d_id])
    if params[:file]
      begin
        Team.transaction do
          @division.players.destroy_all
          @division.teams.destroy_all
          Team.import_csv(@division, params[:file])
        end
      rescue => e
        logger.debug(e.message)
        flash[:alert] = "There are errors in the uploaded file it cannot be processed."
      end
    end
    redirect_to d_path(id: @division)
  end

end
