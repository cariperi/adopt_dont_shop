class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = @application.pets

    if params[:search]
      @found_pets = Pet.search(params[:search]).adoptable
    end
  end
end
