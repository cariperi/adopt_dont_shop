require 'rails_helper'

RSpec.describe 'the admin/application show', type: :features do
  let!(:application_1) { Application.create!(name: 'Chris Simmons', street_address: '123 Main St.', city: 'Columbus', state: 'OH', zipcode: '43210', description: "I'm a good host!", status: 'Pending' )}
  let!(:application_2) { Application.create!(name: 'Jamison Ordway', street_address: '456 Main St.', city: 'Denver', state: 'CO', zipcode: '80202', description: "I'm a great host!", status: 'Pending' )}
  let!(:application_3) { Application.create!(name: 'Jane Doe', street_address: '1 South Street', city: 'Manhattan', state: 'NY', zipcode: '11231', description: "I love cats.", status: 'Approved' )}
  let!(:application_4) { Application.create!(name: 'Mister Rogers', street_address: '9 North Street', city: 'Philadelphia', state: 'PA', zipcode: '19148', description: "I am so friendly.", status: 'Rejected' )}

  let!(:shelter_1) { Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)}

  let!(:pet_1) { shelter_1.pets.create!(name: 'Jasper', age: 7, breed: 'Maine Coon', adoptable: true )}
  let!(:pet_2) { shelter_1.pets.create!(name: 'Spot', age: 3, breed: 'Singapura', adoptable: true )}
  let!(:pet_3) { shelter_1.pets.create!(name: 'Willow', age: 4, breed: 'Cornish Rex', adoptable: true )}

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

  it 'should display button to reject a pet on a pending application' do
    application_1.pets << pet_1
    application_1.pets << pet_2
    visit "/admin/applications/#{application_1.id}"

    within("#pet-#{pet_1.id}") do
      expect(page).to have_content(pet_1.name)
      expect(page).to have_button("Reject")
    end

    find("#pet-#{pet_1.id}").click_button "Reject"

    expect(current_path).to eq("/admin/applications/#{application_1.id}")
    within("#pet-#{pet_1.id}") do
      expect(page).to have_content(pet_1.name)
      expect(page).to_not have_button("Reject")
      expect(page).to have_content("Rejected")
    end

    within("#pet-#{pet_2.id}") do
      expect(page).to have_content(pet_2.name)
      expect(page).to have_button("Reject")
    end
  end

  it "does not affect the status of other application's pets" do
    application_1.pets << pet_1
    application_1.pets << pet_2
    application_2.pets << pet_1

    visit "/admin/applications/#{application_1.id}"

    find("#pet-#{pet_1.id}").click_button "Approve"

    visit "/admin/applications/#{application_2.id}"

    within("#pet-#{pet_1.id}") do
      expect(page).to have_content(pet_1.name)
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
      expect(page).to_not have_content("Approved")
      expect(page).to_not have_content("Rejected")
    end
  end

  it 'approves an application when all pets on that app are approved' do
    application_1.pets << pet_1
    application_1.pets << pet_2

    visit "/admin/applications/#{application_1.id}"

    find("#pet-#{pet_1.id}").click_button "Approve"
    find("#pet-#{pet_2.id}").click_button "Approve"

    expect(current_path).to eq("/admin/applications/#{application_1.id}")
    within("#app-status") do
      expect(page).to have_content("Approved")
    end
  end

  it 'rejects an application if one or more pets are rejected, and all other pets are approved' do
    application_1.pets << pet_1
    application_1.pets << pet_2
    application_1.pets << pet_3

    visit "/admin/applications/#{application_1.id}"

    find("#pet-#{pet_1.id}").click_button "Approve"
    find("#pet-#{pet_2.id}").click_button "Reject"
    find("#pet-#{pet_3.id}").click_button "Reject"

    expect(current_path).to eq("/admin/applications/#{application_1.id}")
    within("#app-status") do
      expect(page).to have_content("Rejected")
    end
  end
  
  it 'updates pet adoptability post pet approval' do
    application_1.pets << pet_1
    application_1.pets << pet_2
    application_1.pets << pet_3

    visit "/admin/applications/#{application_1.id}"

    find("#pet-#{pet_1.id}").click_button "Approve"
    find("#pet-#{pet_2.id}").click_button "Approve"
    find("#pet-#{pet_3.id}").click_button "Approve"

    visit "/pets/#{pet_1.id}"
    expect(page).to have_content('false')
    
    visit "/pets/#{pet_2.id}"
    expect(page).to have_content('false')
    
    visit "/pets/#{pet_3.id}"
    expect(page).to have_content('false')
  end
end

#save_and_open_page