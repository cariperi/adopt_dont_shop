require 'rails_helper'

RSpec.describe 'the admin/application show', type: :features do
  let!(:application_1) { Application.create!(name: 'Chris Simmons', street_address: '123 Main St.', city: 'Columbus', state: 'OH', zipcode: '43210', description: "I'm a good host!", status: 'Pending' )}
  let!(:application_2) { Application.create!(name: 'Jamison Ordway', street_address: '456 Main St.', city: 'Denver', state: 'CO', zipcode: '80202', description: "I'm a great host!", status: 'In Progress' )}
  let!(:application_3) { Application.create!(name: 'Jane Doe', street_address: '1 South Street', city: 'Manhattan', state: 'NY', zipcode: '11231', description: "I love cats.", status: 'Approved' )}
  let!(:application_4) { Application.create!(name: 'Mister Rogers', street_address: '9 North Street', city: 'Philadelphia', state: 'PA', zipcode: '19148', description: "I am so friendly.", status: 'Rejected' )}

  let!(:shelter_1) { Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)}

  let!(:pet_1) { shelter_1.pets.create!(name: 'Jasper', age: 7, breed: 'Maine Coon', adoptable: true )}
  let!(:pet_2) { shelter_1.pets.create!(name: 'Spot', age: 3, breed: 'Singapura', adoptable: true )}
  let!(:pet_3) { shelter_1.pets.create!(name: 'Willow', age: 4, breed: 'Cornish Rex', adoptable: false )}

  it 'should display button to approve a pet on a pending application' do
    application_1.pets << pet_1
    application_1.pets << pet_2
    visit "/admin/applications/#{application_1.id}"

    within("#pet-#{pet_1.id}") do
      expect(page).to have_content(pet_1.name)
      expect(page).to have_button("Approve")
    end
  
    find("#pet-#{pet_1.id}").click_button "Approve"
    
    expect(current_path).to eq("/admin/applications/#{application_1.id}")
    within("#pet-#{pet_1.id}") do
      expect(page).to have_content(pet_1.name)
      expect(page).to_not have_button("Approve")
      expect(page).to have_content("Approved")
    end
    
    within("#pet-#{pet_2.id}") do
      expect(page).to have_content(pet_2.name)
      expect(page).to have_button("Approve")
    end
  end
end

#save_and_open_page