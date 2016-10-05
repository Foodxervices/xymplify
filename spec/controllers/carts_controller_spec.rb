require 'rails_helper'

describe CartsController, :type => :controller do 
  let!(:user) { create(:admin) }
  before      { sign_in user }  

  describe '#new' do 
    def do_request
      get :new, restaurant_id: kitchen.restaurant_id, type: food_items.first.type, format: :js
    end

    let!(:kitchen)    { create(:kitchen) }
    let!(:food_items) { create_list(:food_item, 2, kitchen_id: kitchen.id) }

    it 'renders view :new' do
      do_request
      expect(assigns(:food_items).size).to eq 2
    end
  end

  describe '#add' do 
    def do_request
      post :add, restaurant_id: restaurant.id, food_item_id: food_item.id, quantity: 5, format: :js
    end

    let!(:order)      { create(:order, user_id: user.id) }
    let!(:food_item)  { create(:food_item, supplier_id: order.supplier_id, kitchen_id: order.kitchen_id) }
    let!(:order_item) { create(:order_item, order: order, food_item: food_item) }
    let!(:restaurant) { food_item.restaurant }

    it 'updates order' do
      do_request
      expect(order_item.reload.quantity).to eq 7
    end
  end
end