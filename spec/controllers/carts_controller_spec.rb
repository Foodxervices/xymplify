require 'rails_helper'

describe CartsController, :type => :controller do 
  let!(:user)       { create(:admin) }
  let!(:restaurant) { create(:restaurant) }
  let!(:kitchen)    { create(:kitchen, restaurant: restaurant) }
  before      { sign_in user }  

  describe '#new' do 
    def do_request
      get :new, restaurant_id: restaurant.id, ids: food_items.map(&:id), format: :js
    end

    let!(:food_items) { create_list(:food_item, 2, restaurant: restaurant) }

    it 'renders view :new' do
      do_request
      expect(assigns(:food_items).size).to eq 2
    end
  end

  describe '#add' do 
    def do_request
      post :add, restaurant_id: restaurant.id, food_item_id: food_item.id, quantity: 5, kitchen_id: kitchen.id, format: :js
    end

    let!(:order)      { create(:order, user_id: user.id, kitchen: kitchen) }
    let!(:food_item)  { create(:food_item, restaurant: restaurant, supplier_id: order.supplier_id, kitchen_ids: [kitchen.id]) }
    let!(:order_item) { create(:order_item, order: order, food_item: food_item) }

    it 'updates order' do
      do_request
      expect(order_item.reload.quantity).to eq 7
    end
  end

  describe '#confirm' do 
    def do_request
      get :confirm, restaurant_id: order.restaurant_id, id: order.id, format: :js
    end

    let!(:order) { create(:order, status: :wip, user: user) }

    it 'renders view :confirm' do 
      do_request
      expect(assigns(:order)).to match order
    end
  end

  describe '#purchase' do 
    def do_request
      post :purchase, restaurant_id: order.restaurant_id, id: order.id, order: { outlet_name: 'New Outlet Name' }, format: :js
    end

    let!(:order) { create(:order, status: :wip, user: user) }

    it 'updates status to placed' do 
      do_request
      expect(assigns(:order).status.placed?).to eq true
      expect(assigns(:order).outlet_name).to eq 'New Outlet Name'
    end
  end
end