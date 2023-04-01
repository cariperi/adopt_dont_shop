require "rails_helper"

RSpec.describe Application, type: :model do
  describe "relationships" do
    it { should have_many :pet_applications}
  end

  describe 'validations' do
    it {validate_presence_of :name}
    it {validate_presence_of :street_address}
    it {validate_presence_of :city}
    it {validate_presence_of :state}
    it {validate_presence_of :zipcode}
  end
end
