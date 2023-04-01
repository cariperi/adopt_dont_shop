require 'rails_helper'

RSpec.describe 'the application show', type: :features do
  let!(:application_1) { Application.create!(name: 'Chris Simmons', street_address: '123 Main St.', city: 'Columbus', state: 'OH', zipcode: '43210', description: "I'm a good host!", status: 'Pending' )}
  let!(:application_2) { Application.create!(name: 'Jamison Ordway', street_address: '456 Main St.', city: 'Denver', state: 'CO', zipcode: '80202', description: "I'm a great host!", status: 'In Progress' )}

  let!(:shelter_1) { Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)}

  let!(:pet_1) { shelter_1.pets.create!(name: 'Jasper', age: 7, breed: 'Maine Coon', adoptable: true )}
  let!(:pet_2) { shelter_1.pets.create!(name: 'Spot', age: 3, breed: 'Singapura', adoptable: true )}

  it "shows the application and all it's attributes" do
    application_1.pets << pet_1
    pet_2.applications << application_2

    visit "/applications/#{application_1.id}"

    expect(page).to have_content(application_1.name)
    expect(page).to have_content(application_1.street_address)
    expect(page).to have_content(application_1.city)
    expect(page).to have_content(application_1.state)
    expect(page).to have_content(application_1.zipcode)
    expect(page).to have_content(application_1.description)
    expect(page).to have_content(pet_1.name)
    expect(page).to have_content(application_1.status)

    expect(page).to_not have_content(application_2.name)
    expect(page).to_not have_content(application_2.street_address)
    expect(page).to_not have_content(application_2.city)
    expect(page).to_not have_content(application_2.state)
    expect(page).to_not have_content(application_2.zipcode)
    expect(page).to_not have_content(application_2.description)
    expect(page).to_not have_content(pet_2.name)
    expect(page).to_not have_content(application_2.status)

    click_on(pet_1.name)

    expect(current_path).to eq("/pets/#{pet_1.id}")
  end
end
