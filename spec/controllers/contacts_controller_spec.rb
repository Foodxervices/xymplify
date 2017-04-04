require 'rails_helper'

describe ContactsController, :type => :controller do 
  describe 'Signed In' do 
    let!(:user) { create(:admin) }

    before { sign_in user }  

    describe '#index' do
      def do_request
        get :index
      end
     
      let!(:contacts) { create_list(:contact, 2) }

      it 'renders the :index view' do
        do_request
        expect(assigns(:contacts).size).to eq 2
        expect(response).to render_template :index
      end
    end

    describe '#destroy' do 
      def do_request
        delete :destroy, id: contact.id
      end

      let!(:contact) { create(:contact) }

      before do
        request.env["HTTP_REFERER"] = "where_i_came_from"
      end

      it 'deletes contact' do 
        expect{ do_request }.to change{ Contact.count }.from(1).to(0)
        expect(flash[:notice]).to eq('Contact has been deleted.')
        expect(response).to redirect_to "where_i_came_from"
      end
    end
  end

  describe 'Not Signed In' do 
    describe '#new' do 
      def do_request
        get :new
      end

      it 'assigns a new contact and renders the :new view' do 
        do_request 
        expect(assigns(:contact)).to be_a_new Contact
        expect(response).to render_template :new
      end
    end

    describe '#create' do 
      def do_request
        post :create, contact: contact.attributes
      end

      let(:contact) { build(:contact) }

      it 'creates a contact' do 
        expect{ do_request }.to change{ [Contact.count] }.from([0]).to([1])
        expect(response).to redirect_to new_contact_path
      end
    end
  end
end