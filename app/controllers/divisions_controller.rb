class DivisionsController < ApplicationController

  def index
    division = Division.create name: "(set name)"
    redirect_to d_path(id: division)
  end

  def show
    @division = Division.find_by(uuid: params[:id])
    if @division
      # Looks good for now.
    else
      redirect_to root_path
    end
  end

end
