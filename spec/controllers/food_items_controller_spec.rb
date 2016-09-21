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

  describe '#create' do 
    def do_request
      post :create, restaurant_id: restaurant.id, food_item: food_item.attributes
    end

    let!(:kitchen)  { create(:kitchen, restaurant_id: restaurant.id) }
    let(:food_item) { build(:food_item, kitchen_id: kitchen.id) }

    it 'creates a food item' do 
      expect{ do_request }.to change{ [FoodItem.count] }.from([0]).to([1])
      expect(response).to redirect_to [restaurant, :food_items]
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, id: food_item.id
    end

    let!(:food_item) { create(:food_item) }

    it 'returns edit page' do
      do_request
      expect(assigns(:food_item)).to match food_item
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, id: food_item.id, food_item: { code: new_code }
    end

    let!(:food_item) { create(:food_item) }
    let!(:new_code)  { 'KL30902' }

    it 'updates food item' do
      do_request
      expect(food_item.reload.code).to eq new_code
      expect(flash[:notice]).to eq 'Food Item has been updated.'
      expect(response).to redirect_to [food_item.restaurant, :food_items]
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