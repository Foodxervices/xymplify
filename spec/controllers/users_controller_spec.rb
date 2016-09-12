require 'rails_helper'

describe UsersController, :type => :controller do 
  let!(:user) { create(:user) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index
    end

    let!(:users) { create_list(:user, 2) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:users)).to match users
      expect(response).to render_template :index
    end
  end

  describe '#new' do 
    def do_request
      get :new 
    end

    it 'assigns a new user and renders the :new view' do 
      do_request 
      expect(assigns(:user)).to be_a_new User
      expect(response).to render_template :new
    end
  end

  describe '#create' do 
    def do_request
      post :create, user: user.attributes
    end

    let(:user) { build(:user) }

    it 'creates a user' do 
      expect{ do_request }.to change{ [User.count] }.from([0]).to([1])
      expect(response).to redirect_to users_url
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, id: user.id
    end

    let!(:user) { create(:user) }

    it 'returns edit page' do
      do_request
      expect(assigns(:user)).to match user
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, id: user.id, user: { name: new_name }
    end

    let!(:user)  { create(:user) }
    let!(:new_name)  { 'Vinamilk' }

    it 'updates user' do
      do_request
      expect(user.reload.name).to eq new_name
      expect(flash[:notice]).to eq 'User has been updated.'
      expect(response).to redirect_to users_url
    end
  end

  describe '#destroy' do 
    def do_request
      delete :destroy, id: user.id
    end

    let!(:user) { create(:user) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'deletes user' do 
      expect{ do_request }.to change{ User.count }.from(1).to(0)
      expect(flash[:notice]).to eq('User has been deleted.')
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end