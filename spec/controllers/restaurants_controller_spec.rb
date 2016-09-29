require 'rails_helper'

describe RestaurantsController, :type => :controller do 
  let!(:user) { create(:admin) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index
    end

    let!(:restaurants) { create_list(:restaurant, 2) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:restaurants).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#new' do 
    def do_request
      get :new 
    end

    it 'assigns a new restaurant and renders the :new view' do 
      do_request 
      expect(assigns(:restaurant)).to be_a_new Restaurant
      expect(response).to render_template :new
    end
  end

  describe '#create' do 
    def do_request
      post :create, restaurant: restaurant.attributes
    end

    let(:restaurant) { build(:restaurant) }

    it 'creates a restaurant' do 
      expect{ do_request }.to change{ [Restaurant.count] }.from([0]).to([1])
      expect(response).to redirect_to restaurants_url
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, id: restaurant.id
    end

    let!(:restaurant) { create(:restaurant) }

    it 'returns edit page' do
      do_request
      expect(assigns(:restaurant)).to match restaurant
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, id: restaurant.id, restaurant: { name: new_name }
    end

    let!(:restaurant)  { create(:restaurant) }
    let!(:new_name)  { 'Vinamilk' }

    it 'updates restaurant' do
      do_request
      expect(restaurant.reload.name).to eq new_name
      expect(flash[:notice]).to eq 'Restaurant has been updated.'
      expect(response).to redirect_to restaurants_url
    end
  end

  describe '#destroy' do 
    def do_request
      delete :destroy, id: restaurant.id
    end

    let!(:restaurant) { create(:restaurant) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'deletes restaurant' do 
      expect{ do_request }.to change{ Restaurant.count }.from(1).to(0)
      expect(flash[:notice]).to eq('Restaurant has been deleted.')
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end