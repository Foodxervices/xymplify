require 'rails_helper'

describe CategoriesController, :type => :controller do 
  let!(:user)       { create(:admin) }
  let!(:kitchen)    { create(:kitchen) }
  let!(:food_items) { create_list(:food_item, 2, kitchen_ids: kitchen.id, tag_list: 'Drink') }

  before do 
    sign_in user 
    @request.session['restaurant_id'] = kitchen.restaurant_id
    @request.session['kitchen_id'] = kitchen.id
  end

  describe '#index' do
    def do_request
      get :index
    end

    it 'renders the :index view' do
      do_request
      expect(assigns(:food_items).size).to eq 2
      expect(assigns(:groups).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#by_supplier' do
    def do_request
      get :by_supplier
    end

    it 'renders the :index view' do
      do_request
      expect(assigns(:food_items).size).to eq 2
      expect(assigns(:groups).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#frequently_ordered' do
    def do_request
      get :frequently_ordered
    end

    it 'renders the :index view' do
      do_request
      expect(assigns(:food_items).size).to eq 2
      expect(assigns(:groups).size).to eq 1
      expect(response).to render_template :index
    end
  end
end