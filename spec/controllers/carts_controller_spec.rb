require 'rails_helper'

describe CartsController, :type => :controller do
  let!(:user)       { create(:admin) }
  let!(:kitchen)    { create(:kitchen) }
  before      { sign_in user }

  describe '#new' do
    def do_request
      get :new, kitchen_id: kitchen.id, ids: food_items.map(&:id), format: :js
    end

    let!(:food_items) { create_list(:food_item, 2, kitchen_ids: kitchen.id) }

    it 'renders view :new' do
      do_request
      expect(assigns(:food_items).size).to eq 2
    end
  end

  describe '#add' do
    def do_request
      post :add, kitchen_id: kitchen.id, food_item_id: food_item.id, quantity: 5, format: :js
    end

    let!(:order)      { create(:order, user_id: user.id, kitchen: kitchen) }
    let!(:food_item)  { create(:food_item, supplier_id: order.supplier_id, kitchen_ids: kitchen.id) }
    let!(:order_item) { create(:order_item, order: order, food_item: food_item, quantity: 2) }

    it 'updates order' do
      do_request
      expect(assigns(:item).quantity).to eq 7
    end
  end

  describe '#confirm' do
    def do_request
      get :confirm, kitchen_id: order.kitchen_id, id: order.id, format: :js
    end

    let!(:order) { create(:order, status: :wip, user: user) }

    it 'renders view :confirm' do
      do_request
      expect(assigns(:order)).to match order
    end
  end

  describe '#do_confirm' do
    def do_request
      post :do_confirm, kitchen_id: order.kitchen_id, id: order.id, order: { outlet_name: 'New Outlet Name' }, format: :js
    end

    let!(:order) { create(:order, status: :wip, user: user) }

    it 'updates status to confirmed' do
      do_request
      expect(assigns(:order).status.confirmed?).to eq true
      expect(assigns(:order).outlet_name).to eq 'New Outlet Name'
    end
  end
end