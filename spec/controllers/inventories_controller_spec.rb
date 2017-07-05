require 'rails_helper'

describe InventoriesController, :type => :controller do
  let!(:kitchen)    { create(:kitchen) }
  let!(:user)       { create(:admin) }

  before do
    sign_in user
    @request.session['restaurant_id'] = kitchen.restaurant_id
    @request.session['kitchen_id'] = kitchen.id
  end

  describe '#index' do
    def do_request
      get :index
    end


    let!(:inventories)       { create_list(:inventory, 2, kitchen: kitchen) }
    let!(:other_inventories) { create_list(:inventory, 1) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:inventories).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#show' do
    def do_request
      get :show, id: inventory.id, format: :js
    end


    let!(:inventory)       { create(:inventory, kitchen: kitchen) }

    it 'renders the :show view' do
      do_request
      expect(assigns(:inventory)).to match inventory
      expect(response).to render_template :show
    end
  end

  describe '#update' do
    def do_request
      patch :update, id: inventory.id, inventory: { current_quantity: new_current_quantity }, format: :js
    end

    let!(:inventory) { create(:inventory, kitchen: kitchen) }
    let!(:new_current_quantity)  { 3000 }

    it 'updates inventory' do
      do_request
      expect(inventory.reload.current_quantity).to eq new_current_quantity
    end
  end
end