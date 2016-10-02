require 'rails_helper'

describe UsersController, :type => :controller do 
  let!(:admin) { create(:admin) }
  before       { sign_in admin }  

  describe '#index' do
    def do_request
      get :index
    end

    let!(:users) { create_list(:admin, 2) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:users).size).to eq 3
      expect(response).to render_template :index
    end
  end

  describe '#show' do
    def do_request
      get :show, id: user.id, format: :js
    end

    let!(:user) { create(:admin) }

    it 'renders the :show view' do
      do_request
      expect(assigns(:user)).to match user
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
      post :create, user: attributes_for(:admin)
    end

    it 'creates a user' do 
      expect{ do_request }.to change{ [User.count] }.from([1]).to([2])
      expect(response).to redirect_to users_url
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, id: user.id
    end

    let!(:user) { create(:admin) }

    it 'returns edit page' do
      do_request
      expect(assigns(:user)).to match user
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, id: user.id, user: { email: new_email }
    end

    let!(:user)       { create(:admin) }
    let!(:new_email)  { 'new_email@gmail.com' }

    it 'updates user' do
      do_request
      expect(user.reload.email).to eq new_email
      expect(flash[:notice]).to eq 'User has been updated.'
      expect(response).to redirect_to users_url
    end
  end

  describe '#destroy' do 
    def do_request
      delete :destroy, id: user.id
    end

    let!(:user) { create(:admin) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'deletes user' do 
      expect{ do_request }.to change{ User.count }.from(2).to(1)
      expect(flash[:notice]).to eq('User has been deleted.')
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end