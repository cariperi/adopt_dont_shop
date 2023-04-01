class PetApplicationsController < ApplicationController
  def create
    PetApplication.create(pet_application_params)
    redirect_back fallback_location: "/applications"
  end

  private
  def pet_application_params
    params.require(:pet_application).permit(:pet_id, :application_id)
  end
end
