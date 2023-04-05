require 'rails_helper'

RSpec.describe 'the admin/shelters index' do
  let!(:shelter_1) { Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9) }
  let!(:shelter_2) { Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5) }
  let!(:shelter_3) { Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10) }
  let!(:pet_1) { shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true) }
  let!(:pet_2) { shelter_3.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true) }
  let!(:pet_3) { shelter_2.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true) }

  let!(:application_1) { Application.create!(name: 'Chris Simmons', street_address: '123 Main St.', city: 'Columbus', state: 'OH', zipcode: '43210', description: "I'm a good host!", status: 'Pending' )}
  let!(:application_2) { Application.create!(name: 'Jamison Ordway', street_address: '456 Main St.', city: 'Denver', state: 'CO', zipcode: '80202', description: "I'm a great host!", status: 'Pending' )}

  it 'should display all shelters in descending order by name' do
    visit '/admin/shelters'

    expect(page).to have_content(shelter_1.name)
    expect(page).to have_content(shelter_2.name)
    expect(page).to have_content(shelter_3.name)
    expect(shelter_2.name).to appear_before(shelter_3.name)
    expect(shelter_3.name).to appear_before(shelter_1.name)
    expect(shelter_1.name).to_not appear_before(shelter_2.name)
  end

  it 'should show a section for Shelters with Pending Applications' do
    application_1.pets << pet_1
    application_1.pets << pet_3

    visit '/admin/shelters'

    expect(page).to have_content("Shelters with Pending Applications")
    
    within("#with_pending_apps") do
      expect(page).to have_content(shelter_1.name)
      expect(page).to have_content(shelter_2.name)
      expect(page).to_not have_content(shelter_3.name)
    end
  end
  
  it 'should show a section for Shelters with Pending Applications in alphabetical order' do
    application_1.pets << pet_1
    application_1.pets << pet_3
    application_2.pets << pet_2 

    visit '/admin/shelters'

    expect(page).to have_content("Shelters with Pending Applications")
    
    within("#with_pending_apps") do
      expect(page).to have_content(shelter_1.name)
      expect(page).to have_content(shelter_2.name)
      expect(page).to have_content(shelter_3.name)
    end
  end

  it 'Should display all shelter names as links' do
    visit '/admin/shelters'

    click_link "#{shelter_1.name}"
    expect(current_path).to eq("/admin/shelters/#{shelter_1.id}")
   
    visit '/admin/shelters'

    click_link "#{shelter_2.name}"
    expect(current_path).to eq("/admin/shelters/#{shelter_2.id}")
    
    visit '/admin/shelters'
    
    click_link "#{shelter_3.name}"
    expect(current_path).to eq("/admin/shelters/#{shelter_3.id}")
  end
end