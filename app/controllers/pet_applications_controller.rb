class PetApplicationsController < ApplicationController
  def create
    pet_application = PetApplication.create(pet_application_params)
    application = pet_application.application
    redirect_to "/applications/#{application.id}"
  end

  def update
    pet_application = PetApplication.find(params[:id])
    pet_application.update(pet_status: params[:pet_status])
    application = pet_application.application
    redirect_to "/admin/applications/#{application.id}"
  end

  private
  def pet_application_params
    params.require(:pet_application).permit(:pet_id, :application_id, :pet_status)
  end
end
