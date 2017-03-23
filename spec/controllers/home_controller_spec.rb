require 'rails_helper'

describe HomeController, :type => :controller do
  describe '#index' do
    def do_request
      get :index
    end

    it 'renders the :index view' do
      do_request
      expect(response).to render_template :index
    end
  end

  describe '#retailers' do
    def do_request
      get :retailers
    end

    it 'renders the :retailers view' do
      do_request
      expect(response).to render_template :retailers
    end
  end

  describe '#how_it_works' do
    def do_request
      get :how_it_works
    end

    it 'renders the :how_it_works view' do
      do_request
      expect(response).to render_template :how_it_works
    end
  end
end