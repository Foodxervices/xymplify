require 'rails_helper'

describe RolesController, :type => :controller do 
  let!(:user) { create(:admin) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index
    end

    let!(:roles) { create_list(:role, 2) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:roles)).to match roles
      expect(response).to render_template :index
    end
  end

  describe '#new' do 
    def do_request
      get :new 
    end

    it 'assigns a new role and renders the :new view' do 
      do_request 
      expect(assigns(:role)).to be_a_new Role
      expect(response).to render_template :new
    end
  end

  describe '#create' do 
    def do_request
      post :create, role: role.attributes
    end

    let(:role) { build(:role) }

    it 'creates a role' do 
      expect{ do_request }.to change{ [Role.count] }.from([0]).to([1])
      expect(response).to redirect_to roles_url
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, id: role.id
    end

    let!(:role) { create(:role) }

    it 'returns edit page' do
      do_request
      expect(assigns(:role)).to match role
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, id: role.id, role: { name: new_name }
    end

    let!(:role)  { create(:role) }
    let!(:new_name)  { 'Manager' }

    it 'updates role' do
      do_request
      expect(role.reload.name).to eq new_name
      expect(flash[:notice]).to eq 'Role has been updated.'
      expect(response).to redirect_to roles_url
    end
  end

  describe '#destroy' do 
    def do_request
      delete :destroy, id: role.id
    end

    let!(:role) { create(:role) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'deletes role' do 
      expect{ do_request }.to change{ Role.count }.from(1).to(0)
      expect(flash[:notice]).to eq('Role has been deleted.')
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end