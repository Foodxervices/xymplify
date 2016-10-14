require 'rails_helper'

describe InventoriesController, :type => :controller do 
  let!(:restaurant) { create(:restaurant) }
  let!(:user)       { create(:admin) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index, restaurant_id: restaurant.id
    end

    let!(:kitchen)          { create(:kitchen, restaurant_id: restaurant.id) }
    let!(:food_items)       { create_list(:food_item, 2, kitchen_id: kitchen.id, current_quantity: 2) }
    let!(:other_food_items) { create_list(:food_item, 1) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:food_items).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#update_current_quantity' do 
    def do_request
      patch :update_current_quantity, restaurant_id: restaurant.id, id: food_item.id, food_item: { current_quantity: new_current_quantity }
    end

    let!(:kitchen)   { create(:kitchen, restaurant_id: restaurant.id) }
    let!(:food_item) { create(:food_item, kitchen_id: kitchen.id) }
    let!(:new_current_quantity)  { 3000 }

    it 'updates food item' do
      do_request
      expect(food_item.reload.current_quantity).to eq new_current_quantity
    end
  end
end