require 'rails_helper'

describe InventoriesController, :type => :controller do 
  let!(:restaurant) { create(:restaurant) }
  let!(:kitchen)    { create(:kitchen, restaurant: restaurant) }
  let!(:food_item)  { create(:food_item, restaurant: restaurant, kitchen_ids: [kitchen.id]) }
  let!(:user)       { create(:admin) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index, restaurant_id: restaurant.id
    end

    
    let!(:inventories)       { create_list(:inventory, 2, restaurant: restaurant, food_item: food_item, current_quantity: 2) }
    let!(:other_inventories) { create_list(:inventory, 1) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:inventories).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#update' do 
    def do_request
      patch :update, restaurant_id: restaurant.id, id: inventory.id, inventory: { current_quantity: new_current_quantity }
    end

    let!(:inventory) { create(:inventory, restaurant: restaurant, food_item: food_item) }
    let!(:new_current_quantity)  { 3000 }

    it 'updates inventory' do
      do_request
      expect(inventory.reload.current_quantity).to eq new_current_quantity
    end
  end
end