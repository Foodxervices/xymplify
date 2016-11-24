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

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'updates user' do
      do_request
      expect(user.reload.email).to eq new_email
      expect(flash[:notice]).to eq 'Profile has been updated.'
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end