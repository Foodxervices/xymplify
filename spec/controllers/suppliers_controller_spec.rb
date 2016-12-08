require 'rails_helper'

describe SuppliersController, :type => :controller do 
  let!(:restaurant)   { create(:restaurant) }
  let!(:user)         { create(:admin) }

  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index, restaurant_id: restaurant.id
    end
   
    let!(:suppliers)        { create_list(:supplier, 2, restaurant_id: restaurant.id) }
    let!(:other_suppliers)  { create_list(:supplier, 1) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:suppliers).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#new' do 
    def do_request
      get :new, restaurant_id: restaurant.id
    end

    it 'assigns a new supplier and renders the :new view' do 
      do_request 
      expect(assigns(:supplier)).to be_a_new Supplier
      expect(response).to render_template :new
    end
  end

  describe '#create' do 
    def do_request
      post :create, restaurant_id: restaurant.id, supplier: supplier.attributes
    end

    let(:supplier) { build(:supplier) }

    it 'creates a supplier' do 
      expect{ do_request }.to change{ [Supplier.count] }.from([0]).to([1])
      expect(response).to redirect_to [restaurant, :suppliers]
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, restaurant_id: restaurant.id, id: supplier.id
    end

    let!(:supplier) { create(:supplier, restaurant: restaurant) }

    it 'returns edit page' do
      do_request
      expect(assigns(:supplier)).to match supplier
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, restaurant_id: restaurant.id, id: supplier.id, supplier: { name: new_name }
    end

    let!(:supplier)  { create(:supplier, restaurant: restaurant) }
    let!(:new_name)  { 'Vinamilk' }

    it 'updates supplier' do
      do_request
      expect(supplier.reload.name).to eq new_name
      expect(flash[:notice]).to eq 'Supplier has been updated.'
      expect(response).to redirect_to [supplier.restaurant, :suppliers]
    end
  end

  describe '#destroy' do 
    def do_request
      delete :destroy, id: supplier.id
    end

    let!(:supplier) { create(:supplier) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'deletes supplier' do 
      expect{ do_request }.to change{ Supplier.count }.from(1).to(0)
      expect(flash[:notice]).to eq('Supplier has been deleted.')
      expect(response).to redirect_to "where_i_came_from"
    end
  end

  describe '#update_priority' do 
    def do_request
      patch :update_priority, ids: [foodxervices.id, vinamilk.id]
    end

    let!(:foodxervices) { create(:supplier) }
    let!(:vinamilk)     { create(:supplier) }

    it 'updates supplier' do
      expect(foodxervices.priority).to eq nil
      do_request
      expect(foodxervices.reload.priority).to eq 1
      expect(vinamilk.reload.priority).to eq 2
      expect(response).to render_template(nil)
    end
  end
end