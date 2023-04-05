class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, length: { is: 5}

  def find_pet_app(pet_id)
    pet_applications.where(pet_id: pet_id).first
  end

  def invalid_zipcode?
    zipcode.size != 5
  end

  def pets_pending_approvals? 
    pet_applications.where(pet_status: 'Pending Approval').any?
  end

  def pets_rejected? 
    pet_applications.where(pet_status: 'Rejected').any?
  end
end
