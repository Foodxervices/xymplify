require 'rails_helper'

describe VersionsController do 
  let!(:user) { create(:admin) }
  before { sign_in user }  

  describe '#index' do 
    def do_request
      get :index, restaurant_id: restaurant.id 
    end

    let!(:restaurant) { create(:restaurant) }

    it 'renders the :index view' do 
      do_request 
      expect(assigns(:versions).size).to eq restaurant.versions.size
    end
  end

  describe '#show' do 
    def do_request 
      get :show, id: Version.first, format: :js
    end

    let!(:food_item) { create(:food_item) }

    it 'renders the :show view' do
      do_request
      expect(assigns(:version)).to match Version.first
    end
  end
end