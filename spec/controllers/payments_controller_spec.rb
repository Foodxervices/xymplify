require 'rails_helper'

describe PaymentsController, :type => :controller do
  let!(:user)         { create(:admin) }
  before { sign_in user }

  describe '#index' do
    def do_request
      get :index, restaurant_id: restaurant.id
    end

    let!(:restaurant)       { create(:restaurant) }
    let!(:suppliers)        { create_list(:supplier, 2, restaurant_id: restaurant.id) }
    let!(:other_suppliers)  { create_list(:supplier, 1) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:suppliers).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#edit' do
    def do_request
      get :edit, id: order.id, format: :js
    end

    let!(:order) { create(:order) }

    it 'returns edit page' do
      do_request
      expect(assigns(:order)).to match order
      expect(response).to render_template :edit
    end
  end

  describe '#update' do
    def do_request
      patch :update, id: order.id, order: { pay_amount: 10 }
    end

    let!(:order) { create(:order) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'updates message' do
      do_request
      expect(order.reload.paid_amount.to_i).to eq 10
      expect(flash[:notice]).to eq 'Payment has been updated.'
      expect(response).to redirect_to "where_i_came_from"
    end
  end

  describe '#history' do
    def do_request
      patch :history, order_id: payment_history.order_id, format: :js
    end

    let!(:payment_history) { create(:payment_history) }

    it 'renders the :history view' do
      do_request
      expect(assigns(:payments).size).to eq 1
      expect(response).to render_template :history
    end
  end
end