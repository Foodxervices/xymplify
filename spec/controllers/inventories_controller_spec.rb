require 'rails_helper'

describe InventoriesController, :type => :controller do 
  let!(:user) { create(:user) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index
    end

    let!(:food_items) { create_list(:food_item, 2, user: user) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:food_items)).to match food_items
      expect(response).to render_template :index
    end
  end
end