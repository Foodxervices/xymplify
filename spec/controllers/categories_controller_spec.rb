require 'rails_helper'

describe CategoriesController, :type => :controller do 
  let!(:admin)   { create(:admin) }
  let!(:kitchen) { create(:kitchen) }
  let!(:food_items) { create_list(:food_item, 2, kitchen: kitchen, tag_list: 'Drink') }

  before       { sign_in admin }  

  describe '#index' do
    def do_request
      get :index, restaurant_id: kitchen.restaurant_id
    end

    it 'renders the :index view' do
      do_request
      expect(assigns(:categories).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#by_supplier' do
    def do_request
      get :by_supplier, restaurant_id: kitchen.restaurant_id
    end

    it 'renders the :index view' do
      do_request
      expect(assigns(:categories).size).to eq 2
      expect(response).to render_template :index
    end
  end
end