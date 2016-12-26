require 'rails_helper'

describe ConfigsController, :type => :controller do 
  let!(:admin) { create(:admin) }
  before       { sign_in admin }  

  describe '#index' do
    def do_request
      get :index
    end

    let!(:configs) { create_list(:config, 2) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:configs).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, id: config.id, format: :js
    end

    let!(:config) { create(:config) }

    it 'returns edit page' do
      do_request
      expect(assigns(:config)).to match config
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, id: config.id, config: { value: new_value }
    end

    let!(:config)      { create(:config) }
    let!(:new_value)   { 'New Config Value' }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'updates config' do
      do_request
      expect(config.reload.value).to eq new_value
      expect(flash[:notice]).to eq 'Config has been updated.'
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end