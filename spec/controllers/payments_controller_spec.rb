require 'rails_helper'

describe PaymentsController, :type => :controller do
  let!(:user)         { create(:admin) }
  before { sign_in user }

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
      patch :update, id: order.id, order: { paid_amount: new_paid_amount }
    end

    let!(:order) { create(:order) }
    let!(:new_paid_amount)  { 10 }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'updates message' do
      do_request
      expect(order.reload.paid_amount.to_i).to eq new_paid_amount
      expect(flash[:notice]).to eq 'Payment has been updated.'
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end