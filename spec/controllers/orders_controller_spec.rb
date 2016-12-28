require 'rails_helper'

describe OrdersController, :type => :controller do 
  context 'Signed In' do 
    let!(:user) { create(:admin) }
    before      { sign_in user }  

    describe '#index' do 
      def do_request
        get :index, kitchen_id: placed_order.kitchen_id
      end

      let!(:placed_order) { create(:order, status: :placed) }

      it 'renders index view' do
        do_request
        expect(assigns(:orders).size).to eq 1
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
        expect(flash[:notice]).to eq("#{order.full_name} has been deleted.")
        expect(response).to redirect_to "where_i_came_from"
      end
    end

    describe '#mark_as_accepted' do 
      def do_request
        get :mark_as_accepted, id: order.id
      end

      let!(:order) { create(:order, status: :placed) }

      it 'changes status to accepted' do
        do_request
        expect(order.reload.status.accepted?).to eq true
      end
    end

    describe '#mark_as_declined' do 
      def do_request
        get :mark_as_declined, id: order.id
      end

      let!(:order) { create(:order, status: :placed) }

      it 'changes status to declined' do
        do_request
        expect(order.reload.status.declined?).to eq true
      end
    end

    describe '#mark_as_cancelled' do 
      def do_request
        get :mark_as_cancelled, id: order.id
      end

      let!(:order) { create(:order, status: :accepted) }
      before do
        request.env["HTTP_REFERER"] = "where_i_came_from"
      end

      it 'changes status to cancelled' do
        do_request
        expect(order.reload.status.cancelled?).to eq true
        expect(response).to redirect_to "where_i_came_from"
      end
    end

    describe '#mark_as_delivered' do 
      def do_request
        get :mark_as_delivered, id: order.id
      end

      let!(:order) { create(:order, status: :accepted) }
      before do
        request.env["HTTP_REFERER"] = "where_i_came_from"
      end

      it 'changes status to delivered' do
        do_request
        expect(order.reload.status.delivered?).to eq true
        expect(response).to redirect_to "where_i_came_from"
      end
    end

    describe '#new_attachment' do 
      def do_request
        get :new_attachment, id: order.id, format: :js
      end

      let!(:order) { create(:order) }

      it 'returns new_attachment page' do
        do_request
        expect(assigns(:order)).to match order
        expect(response).to render_template 'orders/attachment/new'
      end
    end
  end

  context 'Public' do 
    describe '#mark_as_accepted' do 
      def do_request
        get :mark_as_accepted, id: order.id, token: token
      end

      let!(:order) { create(:order, status: :placed, token: 'token') }

      context 'Valid Token' do
        let!(:token) { order.token }

        it 'changes status to accepted' do
          do_request
          expect(order.reload.status.accepted?).to eq true
        end
      end

      context 'Invalid Token' do
        let!(:token) { 'invalid_token' }

        it 'does not change status' do
          do_request
          expect(order.reload.status.accepted?).to eq false
        end
      end
    end

    describe '#mark_as_declined' do 
      def do_request
        get :mark_as_declined, id: order.id, token: token
      end

      let!(:order) { create(:order, status: :placed, token: 'token') }

      context 'Valid Token' do
        let!(:token) { order.token }

        it 'changes status to declined' do
          do_request
          expect(order.reload.status.declined?).to eq true
        end
      end

      context 'Invalid Token' do
        let!(:token) { 'invalid_token' }

        it 'does not change status' do
          do_request
          expect(order.reload.status.declined?).to eq false
        end
      end
    end
  end
end