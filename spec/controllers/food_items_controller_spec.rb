require 'rails_helper'

describe FoodItemsController, :type => :controller do
  describe '#index' do
    def do_request
      get :index
    end

    let!(:user) { create(:user) }

    before { sign_in user }

    it 'renders the :index view' do
      do_request
      expect(response).to render_template :index
    end
  end
end