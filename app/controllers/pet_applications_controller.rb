class PetApplicationsController < ApplicationController
  def create
    pet_application = PetApplication.create(pet_application_params)
    application = pet_application.application
    redirect_to "/applications/#{application.id}"
  end

  def update
    pet_application = PetApplication.find(params[:id])
    pet_application.update(pet_application_params)
    application = pet_application.application
    pets = application.pets

    if !application.pets_rejected? && !application.pets_pending_approvals?
      application.update(status: "Approved")
      pets.update(adoptable: false)
    elsif application.pets_rejected? && !application.pets_pending_approvals?
      application.update(status: "Rejected")
    end

    redirect_to "/admin/applications/#{application.id}"
  end

  private
  def pet_application_params
    params.require(:pet_application).permit(:pet_id, :application_id, :pet_status)
  end
end
