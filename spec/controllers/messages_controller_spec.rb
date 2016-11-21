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
end