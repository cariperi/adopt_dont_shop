class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
    .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
    .group("shelters.id")
    .order("pets_count DESC")
  end

  def self.desc_order
    find_by_sql("SELECT * FROM shelters ORDER BY name DESC;")
  end

  def self.get_details(params_id)
    connection.select_all("SELECT name, city FROM shelters WHERE shelters.id = #{params_id};").rows[0]
  end

  def self.pending_apps
    select('shelters.*').joins(pets: :applications).where("status = 'Pending'")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def pets_avg_age
    adoptable_pets.average(:age).to_i
  end

  def adoptable_pet_count
    adoptable_pets.count
  end
end
