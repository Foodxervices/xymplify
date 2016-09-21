require 'rails_helper'

describe UserRolesController, :type => :controller do 
  let!(:restaurant)   { create(:restaurant) }
  let!(:user)         { create(:admin) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index, restaurant_id: restaurant.id
    end

    let!(:user_roles)       { create_list(:user_role, 2, restaurant_id: restaurant.id) }
    let!(:other_user_roles) { create_list(:user_role, 1) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:user_roles).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#new' do 
    def do_request
      get :new, restaurant_id: restaurant.id
    end

    it 'assigns a new user_role and renders the :new view' do 
      do_request 
      expect(assigns(:user_role)).to be_a_new UserRole
      expect(response).to render_template :new
    end
  end

  describe '#create' do 
    def do_request
      post :create, restaurant_id: restaurant.id, user_role: user_role.attributes
    end

    let(:user_role) { build(:user_role) }

    it 'creates a user_role' do 
      expect{ do_request }.to change{ [UserRole.count] }.from([0]).to([1])
      expect(response).to redirect_to [restaurant, :user_roles]
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, id: user_role.id
    end

    let!(:user_role) { create(:user_role) }

    it 'returns edit page' do
      do_request
      expect(assigns(:user_role)).to match user_role
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, id: user_role.id, user_role: { role_id: new_role.id }
    end

    let!(:user_role) { create(:user_role) }
    let!(:new_role)  { create(:role) }

    it 'updates user_role' do
      do_request
      expect(user_role.reload.role).to eq new_role
      expect(flash[:notice]).to eq 'User Role has been updated.'
      expect(response).to redirect_to [user_role.restaurant, :user_roles]
    end
  end

  describe '#destroy' do 
    def do_request
      delete :destroy, id: user_role.id
    end

    let!(:user_role) { create(:user_role) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'deletes user_role' do 
      expect{ do_request }.to change{ UserRole.count }.from(1).to(0)
      expect(flash[:notice]).to eq('User Role has been deleted.')
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end