require 'rails_helper'

describe DishesController, :type => :controller do 
  let!(:restaurant) { create(:restaurant) }

  before do
    @request.session['restaurant_id'] = restaurant.id
  end

  describe 'Signed In' do 
    let!(:user) { create(:admin) }

    before { sign_in user }  

    describe '#index' do
      def do_request
        get :index
      end
     
      let!(:dishes) { create_list(:dish, 2, restaurant: restaurant) }

      it 'renders the :index view' do
        do_request
        expect(assigns(:dishes).size).to eq 2
        expect(response).to render_template :index
      end
    end

    describe '#new' do 
      def do_request
        get :new, format: :js
      end

      it 'assigns a new dish and renders the :new view' do 
        do_request 
        expect(assigns(:dish)).to be_a_new Dish
        expect(response).to render_template :new
      end
    end

    describe '#create' do 
      def do_request
        post :create, dish: dish.attributes
      end

      let(:dish) { build(:dish) }

      before do
        request.env["HTTP_REFERER"] = "where_i_came_from"
      end

      it 'creates a dish' do 
        expect{ do_request }.to change{ [Dish.count] }.from([0]).to([1])
        expect(response).to redirect_to "where_i_came_from"
      end
    end

    describe '#edit' do 
      def do_request
        get :edit, id: dish.id, format: :js
      end

      let!(:dish) { create(:dish, restaurant: restaurant) }

      it 'returns edit page' do
        do_request
        expect(assigns(:dish)).to match dish
        expect(response).to render_template :edit
      end
    end

    describe '#update' do 
      def do_request
        patch :update, id: dish.id, dish: { name: new_name }
      end

      let!(:dish)      { create(:dish, restaurant: restaurant) }
      let!(:new_name)  { 'New Dish Name' }

      before do
        request.env["HTTP_REFERER"] = "where_i_came_from"
      end

      it 'updates dish' do
        do_request
        expect(dish.reload.name).to eq new_name
        expect(flash[:notice]).to eq 'Dish has been updated.'
        expect(response).to redirect_to "where_i_came_from"
      end
    end

    describe '#destroy' do 
      def do_request
        delete :destroy, id: dish.id
      end

      let!(:dish) { create(:dish, restaurant: restaurant) }

      before do
        request.env["HTTP_REFERER"] = "where_i_came_from"
      end

      it 'deletes dish' do 
        expect{ do_request }.to change{ Dish.count }.from(1).to(0)
        expect(flash[:notice]).to eq('Dish has been deleted.')
        expect(response).to redirect_to "where_i_came_from"
      end
    end
  end
end