require 'rails_helper'

describe FoodItemsController, :type => :controller do
  let!(:user) { create(:user) }
  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index
    end

    let!(:food_items) { create_list(:food_item, 2) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:food_items).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#new' do 
    def do_request
      get :new 
    end

    it 'assigns a new food item and renders the :new view' do 
      do_request 
      expect(assigns(:food_item)).to be_a_new FoodItem
      expect(response).to render_template :new
    end
  end

  describe '#create' do 
    def do_request
      post :create, food_item: food_item.attributes
    end

    let(:food_item) { build(:food_item) }

    it 'creates a food item' do 
      expect{ do_request }.to change{ [FoodItem.count] }.from([0]).to([1])
      expect(response).to redirect_to food_items_url
    end
  end
end