class PlayersController < ApplicationController

  def create
    @division = Division.find_by(uuid: params[:d_id])
    @division.players.destroy_all
    begin
      Player.import_csv(@division, params[:file])
    rescue => e
      logger.debug(e.message)
      flash[:error] = "The file has errors with it."
    end
    redirect_to d_path(id: @division)
  end

end
