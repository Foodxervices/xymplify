require 'rails_helper'

describe SupplierOrdersController, :type => :controller do
  context 'Signed In' do
    let!(:user) { create(:admin) }
    before      { sign_in user }

    describe '#index' do
      def do_request
        get :index, restaurant_id: order.restaurant_id, supplier_id: order.supplier_id
      end

      let!(:order) { create(:order, status: :placed) }

      it 'renders index view' do
        do_request
        expect(assigns(:orders).size).to eq 1
        expect(response).to render_template :index
      end
    end
  end
end