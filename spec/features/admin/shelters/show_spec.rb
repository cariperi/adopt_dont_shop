require 'rails_helper'

RSpec.describe 'admin/shelters show page' do
  let!(:shelter_1) { Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9) }
  let!(:shelter_2) { Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5) }
  let!(:shelter_3) { Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10) }
  let!(:pet_1) { shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true) }
  let!(:pet_2) { shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true) }
  let!(:pet_3) { shelter_2.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true) }

  let!(:application_1) { Application.create!(name: 'Chris Simmons', street_address: '123 Main St.', city: 'Columbus', state: 'OH', zipcode: '43210', description: "I'm a good host!", status: 'Pending' )}

  it 'should display a shelters name and full address' do
    visit "/admin/shelters/#{shelter_1.id}"

    expect(page).to have_content(shelter_1.name)
    expect(page).to have_content(shelter_1.city)

    expect(page).to_not have_content(shelter_2.name)
    expect(page).to_not have_content(shelter_2.city)

    expect(page).to_not have_content(shelter_3.name)
    expect(page).to_not have_content(shelter_3.city)

    visit "/admin/shelters/#{shelter_2.id}"

    expect(page).to have_content(shelter_2.name)
    expect(page).to have_content(shelter_2.city)
  end

  it 'should have a section for statistics with the average age of all adoptable pets for that shelter' do
    visit "/admin/shelters/#{shelter_1.id}"

    expect(page).to have_content("Pet Statistics")
    expect(page).to have_content("Average Age of Adoptable Pets: 4 years")

    visit "/admin/shelters/#{shelter_2.id}"

    expect(page).to have_content("Pet Statistics")
    expect(page).to have_content("Average Age of Adoptable Pets: 8 years")

    visit "/admin/shelters/#{shelter_3.id}"

    expect(page).to have_content("Pet Statistics")
    expect(page).to have_content("No adoptable pets are available at this time.")
  end

  it 'should have a section for statistics with the number of pets at the given shelter that are adoptable' do
    visit "/admin/shelters/#{shelter_1.id}"

    expect(page).to have_content("Pet Statistics")
    expect(page).to have_content("Number of Adoptable Pets: 2")

    visit "/admin/shelters/#{shelter_2.id}"

    expect(page).to have_content("Pet Statistics")
    expect(page).to have_content("Number of Adoptable Pets: 1")

    visit "/admin/shelters/#{shelter_3.id}"

    expect(page).to have_content("Pet Statistics")
    expect(page).to have_content("No adoptable pets are available at this time.")
    expect(page).to_not have_content("Number of Adoptable Pets")
  end
end
