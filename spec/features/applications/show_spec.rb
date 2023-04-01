require 'rails_helper'

RSpec.describe 'the application show', type: :features do
  let!(:application_1) { Application.create!(name: 'Chris Simmons', street_address: '123 Main St.', city: 'Columbus', state: 'OH', zipcode: '43210', description: "I'm a good host!", status: 'Pending' )}
  let!(:application_2) { Application.create!(name: 'Jamison Ordway', street_address: '456 Main St.', city: 'Denver', state: 'CO', zipcode: '80202', description: "I'm a great host!", status: 'In Progress' )}
  let!(:application_3) { Application.create!(name: 'Jane Doe', street_address: '1 South Street', city: 'Manhattan', state: 'NY', zipcode: '11231', description: "I love cats.", status: 'Approved' )}
  let!(:application_4) { Application.create!(name: 'Mister Rogers', street_address: '9 North Street', city: 'Philadelphia', state: 'PA', zipcode: '19148', description: "I am so friendly.", status: 'Rejected' )}

  let!(:shelter_1) { Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)}

  let!(:pet_1) { shelter_1.pets.create!(name: 'Jasper', age: 7, breed: 'Maine Coon', adoptable: true )}
  let!(:pet_2) { shelter_1.pets.create!(name: 'Spot', age: 3, breed: 'Singapura', adoptable: true )}
  let!(:pet_3) { shelter_1.pets.create!(name: 'Willow', age: 4, breed: 'Cornish Rex', adoptable: false )}
  let!(:pet_4) { shelter_1.pets.create!(name: 'Spotty', age: 5, breed: 'Calico', adoptable: true )}
  let!(:pet_5) { shelter_1.pets.create!(name: 'Mr. Spot', age: 2, breed: 'Ocicat', adoptable: true )}
  let!(:pet_6) { shelter_1.pets.create!(name: 'spots', age: 10, breed: 'Egyptian Mau', adoptable: true )}


  it "shows the application and all it's attributes" do
    application_1.pets << pet_1
    application_2.pets << pet_2

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

  it "lets non-submitted applications search for adoptable pets to add to the application" do
    visit "/applications/#{application_2.id}"  #in progress application (not submitted)

    expect(page).to have_content("Add a Pet to this Application")
    expect(page).to have_content("Search for Pets by Name:")
    expect(page).to have_field(:search)
    expect(page).to have_button("Submit")

    fill_in :search, with: "#{pet_1.name}"
    click_button "Submit"

    expect(current_path).to eq("/applications/#{application_2.id}")
    expect(page).to have_content("Results")
    expect(page).to have_content(pet_1.name)
    expect("Search for Pets by Name:").to appear_before(pet_1.name)

    expect(page).to_not have_content(pet_2.name)
    expect(page).to_not have_content(pet_3.name)
  end

  it "shows a message if no pets match the search" do
    visit "/applications/#{application_2.id}"

    fill_in :search, with: "InvalidInput"
    click_button "Submit"

    expect(current_path).to eq("/applications/#{application_2.id}")
    expect(page).to_not have_content("Results")
    expect(page).to have_content("No pets match this search.")
  end

  it "does not display the search for applications that have already been submitted" do
    visit "/applications/#{application_1.id}" #pending application (already submitted)
    expect(page).to_not have_content("Add a Pet to this Application")
    expect(page).to_not have_field(:search)

    visit "/applications/#{application_3.id}" #approved application (already submitted)
    expect(page).to_not have_content("Add a Pet to this Application")
    expect(page).to_not have_field(:search)

    visit "/applications/#{application_4.id}" #rejected application (already submitted)
    expect(page).to_not have_content("Add a Pet to this Application")
    expect(page).to_not have_field(:search)
  end

  it "allows users with in-progress apps to add searched pets to their app" do
    visit "/applications/#{application_2.id}"
    expect(page).to_not have_content(pet_4.name)
    expect(page).to have_content("No pets have been added yet!")

    fill_in :search, with: "Spot"
    click_button "Submit"

    within("#pet-#{pet_2.id}") do
      expect(page).to have_content(pet_2.name)
      expect(page).to have_button("Adopt this Pet")
      expect(pet_2.name).to appear_before("Adopt this Pet")
    end

    within("#pet-#{pet_4.id}") do
      expect(page).to have_content(pet_4.name)
      expect(page).to have_button("Adopt this Pet")
      expect(pet_4.name).to appear_before("Adopt this Pet")
    end

    find("#pet-#{pet_4.id}").click_button("Adopt this Pet")

    expect(current_path).to eq("/applications/#{application_2.id}")
    expect(page).to have_content(pet_4.name)
    expect(page).to_not have_content("No pets have been added yet!")
  end

  it 'can submit an application' do
    #application_2.pets << pet_4
    visit "/applications/#{application_2.id}"
    expect(page).to have_content("In Progress")

    fill_in :search, with: "Spotty"
    click_button "Submit"
    find("#pet-#{pet_4.id}").click_button("Adopt this Pet")

    within("#submitapp") do
      expect(page).to have_content("Submit My Application")
      expect(page).to have_field(:description)
      fill_in :description, with: "I'm a good host!"
      click_button "Submit Application"
    end

    expect(current_path).to eq("/applications/#{application_2.id}")
    expect(page).to have_content("Pending")
    expect(page).to have_content(pet_4.name)
    expect(page).to have_content("I'm a good host!")
    expect(page).to_not have_content("Add a Pet to this Application")
    expect(page).to_not have_field(:search)
  end

  it 'does not show an option to submit if application has no pets' do    visit "/applications/#{application_2.id}"
    expect(page).to have_content("No pets have been added yet!")

    expect(page).to_not have_content("Submit My Application")
    expect(page).to_not have_field(:description)
  end

  it 'can search for pets by PARTIAL name match' do
    visit "/applications/#{application_2.id}"

    fill_in :search, with: "Spot"
    click_button "Submit"

    expect(page).to have_content(pet_2.name)
    expect(page).to have_content(pet_4.name)
    expect(page).to have_content(pet_5.name)
  end

  it 'can search for pets by CASE INSENSITIVE name match' do
    visit "/applications/#{application_2.id}"

    fill_in :search, with: "SPOT"
    click_button "Submit"

    expect(page).to have_content(pet_2.name)
    expect(page).to have_content(pet_4.name)
    expect(page).to have_content(pet_5.name)
    expect(page).to have_content(pet_6.name)

    expect(page).to_not have_content(pet_1.name)

    fill_in :search, with: "sPoT"
    click_button "Submit"

    expect(page).to have_content(pet_2.name)
    expect(page).to have_content(pet_4.name)
    expect(page).to have_content(pet_5.name)
    expect(page).to have_content(pet_6.name)

    expect(page).to_not have_content(pet_1.name)
  end
end


# For example, if I search for "fluff", my search would match pets with names "Fluffy", "FLUFF", and "Mr. FlUfF"