require 'rails_helper'

RSpec.describe 'the Application creation' do
  it 'links to the new page from the applications index' do
    visit '/pets'

    click_link('Start an Application')
    expect(current_path).to eq('/applications/new')
  end

  it 'can create a new application' do
    visit '/applications/new'

    fill_in('Name', with: 'Chris Simmons')
    fill_in('Street Address', with: '123 Main St.')
    fill_in('City', with: 'Columbus')
    fill_in('State', with: 'OH')
    fill_in('Zipcode', with: "43210")
    click_button('Create Application')

    expect(current_path).to eq("/applications/#{Application.last.id}")
    expect(page).to have_content("Chris Simmons")
    expect(page).to have_content("123 Main St.")
    expect(page).to have_content("Columbus")
    expect(page).to have_content("OH")
    expect(page).to have_content("43210")
    expect(page).to have_content("In Progress")
  end

  it 'redirects to new page if form is blank, with the exception of a valid zipcode' do
    visit '/applications/new'

    fill_in('Name', with: "")
    fill_in('Street Address', with: "")
    fill_in('City', with: "")
    fill_in('State', with: "")
    fill_in('Zipcode', with: "43210")
    click_button('Create Application')

    expect(current_path).to eq("/applications/new")
    expect(page).to have_content("ERROR: Please don't leave spaces blank")
    expect(page).to_not have_content("Chris Simmons")
    expect(page).to_not have_content("123 Main St.")
    expect(page).to_not have_content("Columbus")
    expect(page).to_not have_content("OH")
    expect(page).to_not have_content("43210")
    expect(page).to have_button("Create Application")
  end
  
  it 'redirects to new page and displays and error if zipcode is not 5 digits long' do
    visit '/applications/new'

    fill_in('Name', with: 'Chris Simmons')
    fill_in('Street Address', with: '123 Main St.')
    fill_in('City', with: 'Columbus')
    fill_in('State', with: 'OH')
    fill_in('Zipcode', with: "1234")
    click_button('Create Application')

    expect(current_path).to eq("/applications/new")
    expect(page).to have_content("ERROR: Zipcode must be five digits long")
    expect(page).to have_button("Create Application")
    
    fill_in('Name', with: 'Chris Simmons')
    fill_in('Street Address', with: '123 Main St.')
    fill_in('City', with: 'Columbus')
    fill_in('State', with: 'OH')
    fill_in('Zipcode', with: "123456")
    click_button('Create Application')

    expect(current_path).to eq("/applications/new")
    expect(page).to have_content("ERROR: Zipcode must be five digits long")
    expect(page).to have_button("Create Application")
  end
end