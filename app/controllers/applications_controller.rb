class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = @application.pets

    if params[:search]
      @found_pets = Pet.search(params[:search]).adoptable
    end
  end

  def new
  end
  
  def create
    application = Application.new(application_params)
    if application.save
      redirect_to "/applications/#{application.id}"
    else 
      redirect_to '/applications/new'
      flash[:alert] = "ERROR: Please don't leave spaces blank"
    end
  end

private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zipcode, :description)
  end
end
