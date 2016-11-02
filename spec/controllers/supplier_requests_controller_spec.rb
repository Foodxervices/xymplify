require 'rails_helper'

describe SupplierRequestsController, :type => :controller do 
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
end