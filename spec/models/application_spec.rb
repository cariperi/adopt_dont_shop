require "rails_helper"

RSpec.describe Application, type: :model do
  describe "relationships" do
    it { should have_many :pet_applications}
  end

  describe 'validations' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:street_address)}
    it {should validate_presence_of(:city)}
    it {should validate_presence_of(:state)}
    it {should validate_presence_of(:zipcode)}
  end

  describe 'instance methods' do
    let!(:application_1) { Application.create!(name: 'Chris Simmons', street_address: '123 Main St.', city: 'Columbus', state: 'OH', zipcode: '43210', description: "I'm a good host!", status: 'In Progress' )}
    let!(:application_2) { Application.create!(name: 'Jamison Ordway', street_address: '456 Main St.', city: 'Denver', state: 'CO', zipcode: '80202', description: "I'm a great host!", status: 'In Progress' )}

    let!(:shelter_1) { Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)}

    let!(:pet_1) { shelter_1.pets.create!(name: 'Jasper', age: 7, breed: 'Maine Coon', adoptable: true )}
    let!(:pet_2) { shelter_1.pets.create!(name: 'Spot', age: 3, breed: 'Singapura', adoptable: true )}

    let!(:pet_application_1) { PetApplication.create!(pet_id: pet_1.id, application_id: application_1.id)}
    let!(:pet_application_2) { PetApplication.create!(pet_id: pet_1.id, application_id: application_2.id)}
    let!(:pet_application_3) { PetApplication.create!(pet_id: pet_2.id, application_id: application_1.id)}


    describe '#find_pet_app(pet_id)' do
      it 'returns the pet application for the specific app and pet ids' do
        expect(application_1.find_pet_app(pet_1.id)).to eq(pet_application_1)
        expect(application_2.find_pet_app(pet_1.id)).to eq(pet_application_2)
        expect(application_1.find_pet_app(pet_2.id)).to eq(pet_application_3)
      end
    end
  end
end
