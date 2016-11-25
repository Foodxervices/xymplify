require 'rails_helper'

describe MessagesController, :type => :controller do 
  let!(:restaurant)   { create(:restaurant) }
  let!(:user)         { create(:admin) }
  before { sign_in user }  

  describe '#new' do 
    def do_request
      get :new, restaurant_id: restaurant.id, format: :js
    end

    it 'assigns a new message and renders the :new view' do 
      do_request 
      expect(assigns(:message)).to be_a_new Message
      expect(response).to render_template :new
    end
  end

  describe '#create' do 
    def do_request
      post :create, restaurant_id: restaurant.id, message: message.attributes
    end

    let(:message) { build(:message) }

    it 'creates a message' do 
      expect{ do_request }.to change{ [Message.count] }.from([0]).to([1])
      expect(response).to redirect_to [:dashboard, restaurant]
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, restaurant_id: restaurant.id, id: message.id, format: :js
    end

    let!(:message) { create(:message, restaurant: restaurant) }

    it 'returns edit page' do
      do_request
      expect(assigns(:message)).to match message
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, restaurant_id: restaurant.id, id: message.id, message: attributes_for(:message, content: new_content)
    end

    let!(:message) { create(:message, restaurant: restaurant) }
    let!(:new_content)  { 'This is a new content' }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'updates message' do
      do_request
      expect(message.reload.content).to eq new_content
      expect(flash[:notice]).to eq 'Message has been updated.'
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end