require 'rails_helper'

describe OrdersController, :type => :controller do 
  let!(:user) { create(:admin) }
  before      { sign_in user }  

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
      patch :update, id: order.id, order: { items_attributes: [{ id: order.items.first.id, quantity: new_item_quantity }] }, format: :js
    end

    let!(:order) { create(:order) }
    let!(:new_item_quantity) { 1000 }

    it 'updates order' do
      do_request
      expect(order.items.first.reload.quantity).to eq new_item_quantity
    end
  end

  describe '#destroy' do 
    def do_request
      delete :destroy, id: order.id
    end

    let!(:order) { create(:order) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'deletes order' do 
      expect{ do_request }.to change{ Order.count }.from(1).to(0)
      expect(flash[:notice]).to eq("#{order.name} has been deleted.")
      expect(response).to redirect_to "where_i_came_from"
    end
  end
end