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
    elsif application.invalid? && application.invalid_zipcode?
      redirect_to '/applications/new'
      flash[:alert] = "ERROR: Zipcode must be five digits long"
    else
      redirect_to '/applications/new'
      flash[:alert] = "ERROR: Please don't leave spaces blank"
    end
  end

  def update
    @application = Application.find(params[:id])
    @application.update(application_params)
    redirect_to "/applications/#{@application.id}"
  end

private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zipcode, :description, :status)
  end
end
