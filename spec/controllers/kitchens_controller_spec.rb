require 'rails_helper'

describe KitchensController, :type => :controller do
  let!(:user)       { create(:admin) }
  let!(:restaurant) { create(:restaurant) }

  before do
    sign_in user
    @request.session['restaurant_id'] = restaurant.id
  end

  describe '#index' do
    def do_request
      get :index, format: :js
    end

    let!(:kitchens) { create_list(:kitchen, 2, restaurant: restaurant) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:kitchens).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#show' do
    def do_request
      get :show, id: kitchen.id, format: :js
    end

    let!(:kitchen) { create(:kitchen, restaurant: restaurant) }

    it 'renders the :show view' do
      do_request
      expect(assigns(:kitchen)).to match kitchen
    end
  end

  describe '#new' do
    def do_request
      get :new, restaurant_id: restaurant.id, format: :js
    end

    it 'assigns a new kitchen and renders the :new view' do
      do_request
      expect(assigns(:kitchen)).to be_a_new Kitchen
      expect(response).to render_template :new
    end
  end

  describe '#create' do
    def do_request
      post :create, restaurant_id: restaurant.id, kitchen: kitchen.attributes
    end

    let(:kitchen) { build(:kitchen, restaurant: restaurant) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'creates a kitchen' do
      expect{ do_request }.to change{ [Kitchen.count] }.from([0]).to([1])
      expect(response).to redirect_to "where_i_came_from"
    end
  end

  describe '#edit' do
    def do_request
      get :edit, restaurant_id: restaurant.id, id: kitchen.id, format: :js
    end

    let!(:kitchen) { create(:kitchen, restaurant: restaurant) }

    it 'returns edit page' do
      do_request
      expect(assigns(:current_restaurant)).to match restaurant
      expect(response).to render_template :edit
    end
  end

  describe '#update' do
    def do_request
      patch :update, restaurant_id: restaurant.id, id: kitchen.id, kitchen: { name: new_name }
    end

    let!(:kitchen) { create(:kitchen, restaurant: restaurant) }
    let!(:new_name)  { 'Kitchen 2' }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'updates kitchen' do
      do_request
      expect(kitchen.reload.name).to eq new_name
      expect(flash[:notice]).to eq 'Kitchen has been updated.'
      expect(response).to redirect_to "where_i_came_from"
    end
  end

  describe '#dashboard' do
    def do_request
      get :dashboard, id: kitchen.id
    end

    let!(:kitchen) { create(:kitchen, restaurant: restaurant) }

    it 'renders the :dashboard view' do
      do_request
      expect(response).to render_template :dashboard
    end
  end

  describe '#reset_inventory' do
    def do_request
      post :reset_inventory, id: kitchen.id
    end

    let!(:kitchen) { create(:kitchen, restaurant: restaurant) }
    let!(:inventories) { create_list(:inventory, 2, kitchen_id: kitchen.id, current_quantity: 2) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'resets inventory quantity' do
      do_request
      expect(Inventory.last.current_quantity).to eq 0
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end