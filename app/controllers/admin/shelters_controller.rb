class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.desc_order
    @pending_shelters = Shelter.pending_apps
  end
end