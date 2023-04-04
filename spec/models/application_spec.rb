require "rails_helper"

RSpec.describe Application, type: :model do
  describe "relationships" do
    it { should have_many :pet_applications}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zipcode}
  end

  describe 'instance methods' do
    let!(:application_1) { Application.create!(name: 'Chris Simmons', street_address: '123 Main St.', city: 'Columbus', state: 'OH', zipcode: '43210', description: "I'm a good host!", status: 'Pending' )}
    let!(:shelter_1) { Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)}
    let!(:pet_1) { shelter_1.pets.create!(name: 'Jasper', age: 7, breed: 'Maine Coon', adoptable: true )}

    let!(:pet_application_1) { PetApplication.create!(pet_id: pet_1.id, application_id: application_1.id)}

    describe '#find_pet_app(pet_id)' do
      it 'returns the pet application for the specific app and pet ids' do
        expect(application_1.find_pet_app(pet_1.id)).to eq(pet_application_1)
      end
    end
  end
end
