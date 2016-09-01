require 'rails_helper'

describe FoodItemsController, :type => :controller do
  let!(:user) { create(:user) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index
    end

    let!(:food_items) { create_list(:food_item, 2) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:food_items).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#new' do 
    def do_request
      get :new 
    end

    it 'renders the :new view' do 
      do_request 
      expect(assigns(:food_item)).to be_a_new FoodItem
      expect(response).to render_template :new
    end
  end
end