require 'rails_helper'

describe ProfilesController, :type => :controller do 
  let!(:user) { create(:admin) }
  before      { sign_in user }  

  describe '#edit' do 
    def do_request
      get :edit, format: :js
    end

    it 'returns edit page' do
      do_request
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, id: user.id, profile: { email: new_email, current_password: '123123123' }, format: :js
    end

    let!(:new_email)  { 'new_email@gmail.com' }

    it 'updates user' do
      do_request
      expect(user.reload.email).to eq new_email
      expect(flash[:notice]).to eq 'Profile has been updated.'
    end
  end
end