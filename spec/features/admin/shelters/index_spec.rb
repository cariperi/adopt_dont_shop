require 'rails_helper'

RSpec.describe 'the admin/shelters index' do
  let!(:shelter_1) { Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9) }
  let!(:shelter_2) { Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5) }
  let!(:shelter_3) { Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10) }
  let!(:pet_1) { shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true) }
  let!(:pet_2) { shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true) }
  let!(:pet_3) { shelter_2.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true) }

  it 'should display all shelters in descending order by name' do
    visit '/admin/shelters'
save_and_open_page
    expect(page).to have_content(shelter_1.name)    
    expect(page).to have_content(shelter_2.name)    
    expect(page).to have_content(shelter_3.name)    
    expect(shelter_2.name).to appear_before(shelter_3.name)
    expect(shelter_3.name).to appear_before(shelter_1.name)
  end
end