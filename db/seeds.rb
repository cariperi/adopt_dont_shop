# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Application.destroy_all
Shelter.destroy_all
Pet.destroy_all

@application_1 = Application.create!(name: 'Chris Simmons', street_address: '123 Main St.', city: 'Columbus', state: 'OH', zipcode: '43210', description: "I'm a good host!")
@application_2 = Application.create!(name: 'Jamison Ordway', street_address: '456 Main St.', city: 'Denver', state: 'CO', zipcode: '80202', description: "I'm a great host!")
@application_3 = Application.create!(name: 'Jane Doe', street_address: '1 South Street', city: 'Manhattan', state: 'NY', zipcode: '11231', description: "I love cats.")
@application_4 = Application.create!(name: 'Mister Rogers', street_address: '9 North Street', city: 'Philadelphia', state: 'PA', zipcode: '19148', description: "I am so friendly.")

@shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
@shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
@shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

@pet_1 = @shelter_1.pets.create(name: 'Jasper', age: 7, breed: 'Maine Coon', adoptable: true )
@pet_2 = @shelter_1.pets.create(name: 'Spot', age: 3, breed: 'Singapura', adoptable: true )
@pet_3 = @shelter_2.pets.create(name: 'Willow', age: 4, breed: 'Cornish Rex', adoptable: true )
@pet_4 = @shelter_2.pets.create(name: 'Spotty', age: 5, breed: 'Calico', adoptable: true )
@pet_5 = @shelter_3.pets.create(name: 'Mr. Spot', age: 2, breed: 'Ocicat', adoptable: true )
@pet_6 = @shelter_3.pets.create(name: 'spots', age: 10, breed: 'Egyptian Mau', adoptable: true )
