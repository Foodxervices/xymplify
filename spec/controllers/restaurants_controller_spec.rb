require 'rails_helper'

describe RestaurantsController do 
  let!(:user) { create(:admin) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index
    end

    let!(:restaurants) { create_list(:restaurant, 2) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:restaurants).size).to eq 2
      expect(response).to render_template :index
    end
  end
end