require 'rails_helper'

describe FoodItemsController, :type => :controller do
  let!(:restaurant) { create(:restaurant) }
  let!(:user)       { create(:admin) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index, restaurant_id: restaurant.id
    end

    let!(:kitchen)          { create(:kitchen, restaurant_id: restaurant.id) }
    let!(:food_items)       { create_list(:food_item, 2, kitchen_id: kitchen.id) }
    let!(:other_food_items) { create_list(:food_item, 1) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:food_items).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#new' do 
    def do_request
      get :new, restaurant_id: restaurant.id
    end

    it 'assigns a new food item and renders the :new view' do 
      do_request 
      expect(assigns(:food_item)).to be_a_new FoodItem
      expect(response).to render_template :new
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, restaurant_id: food_item.restaurant_id, id: food_item.id
    end

    let!(:food_item) { create(:food_item) }

    it 'returns edit page' do
      do_request
      expect(assigns(:food_item)).to match food_item
      expect(response).to render_template :edit
    end
  end

  describe '#create_or_update' do 
    def do_request
      post :create_or_update, restaurant_id: restaurant.id, food_item: attributes_for(:food_item, code: food_item.code, supplier_id: supplier.id).merge(kitchen_ids: [kitchen_A.id, kitchen_B.id])
    end

    let!(:kitchen_A) { create(:kitchen,  restaurant_id: restaurant.id) }
    let!(:kitchen_B) { create(:kitchen,  restaurant_id: restaurant.id) }
    let!(:supplier)  { create(:supplier, restaurant_id: restaurant.id) }
    let!(:food_item) { create(:food_item, kitchen: kitchen_A, supplier: supplier) }

    it 'updates or creates a food item (if not existed)' do 
      expect{ do_request }.to change{ [FoodItem.count] }.from([1]).to([2])
      expect(response).to redirect_to [restaurant, :food_items]
    end
  end

  describe '#auto_populate' do 
    def do_request
      get :auto_populate, restaurant_id: food_item.restaurant_id, code: food_item.code, format: :js
    end

    let!(:food_item) { create(:food_item) }

    it 'returns food_item' do
      do_request
      expect(assigns(:food_item)).to match food_item
      expect(response).to render_template :auto_populate
    end
  end

  describe '#destroy' do 
    def do_request
      delete :destroy, id: food_item.id
    end

    let!(:food_item) { create(:food_item) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'deletes food item' do 
      expect{ do_request }.to change{ FoodItem.count }.from(1).to(0)
      expect(flash[:notice]).to eq('Food Item has been deleted.')
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end