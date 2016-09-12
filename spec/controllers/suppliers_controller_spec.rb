require 'rails_helper'

describe SuppliersController, :type => :controller do 
  let!(:user) { create(:admin) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index
    end

    let!(:suppliers) { create_list(:supplier, 2) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:suppliers)).to match suppliers
      expect(response).to render_template :index
    end
  end

  describe '#new' do 
    def do_request
      get :new 
    end

    it 'assigns a new supplier and renders the :new view' do 
      do_request 
      expect(assigns(:supplier)).to be_a_new Supplier
      expect(response).to render_template :new
    end
  end

  describe '#create' do 
    def do_request
      post :create, supplier: supplier.attributes
    end

    let(:supplier) { build(:supplier) }

    it 'creates a supplier' do 
      expect{ do_request }.to change{ [Supplier.count] }.from([0]).to([1])
      expect(response).to redirect_to suppliers_url
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, id: supplier.id
    end

    let!(:supplier) { create(:supplier) }

    it 'returns edit page' do
      do_request
      expect(assigns(:supplier)).to match supplier
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, id: supplier.id, supplier: { name: new_name }
    end

    let!(:supplier)  { create(:supplier) }
    let!(:new_name)  { 'Vinamilk' }

    it 'updates supplier' do
      do_request
      expect(supplier.reload.name).to eq new_name
      expect(flash[:notice]).to eq 'Supplier has been updated.'
      expect(response).to redirect_to suppliers_url
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
end