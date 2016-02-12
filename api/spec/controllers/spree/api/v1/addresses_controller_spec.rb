require 'spec_helper'

module Spree
  describe Api::V1::AddressesController, type: :controller do
    render_views

    let(:address) { create(:address) }
    let(:order) { create(:order, bill_address: address) }

    before do
      stub_authentication!
      allow_any_instance_of(Order).to receive_messages user: current_api_user
    end

    def send_show_api_request(options = {})
      api_get :show, id: options[:address].id, order_id: options[:order].number
    end

    def send_update_api_request(options = {})
      api_put :update, id: options[:address].id, order_id: options[:order].number,
                       address: { address1: options[:address1] }

    end

    context "with their own address" do
      it "gets an address" do
        send_show_api_request({ address: address, order: order })
        expect(json_response['address1']).to eq address.address1
      end

      it "updates an address" do
        send_update_api_request({ address: address, order: order, address1: '123 Test Lane' })
        expect(json_response['address1']).to eq '123 Test Lane'
      end

      it "receives the errors object if address is invalid" do
        send_update_api_request({ address: address, order: order, address1: '' })
        expect(json_response['error']).not_to be_nil
        expect(json_response['errors']).not_to be_nil
        expect(json_response['errors']['address1'].first).to eq "can't be blank"
      end
    end

    context "on an address that does not belong to this order" do
      let(:address2) { create(:address) }

      it "cannot retrieve address information" do
        send_show_api_request({ address: address2, order: order })
        assert_not_found!
      end

      it "cannot update address information" do
        send_update_api_request({ address: address2, order: order, address1: '123 Test Lane' })
        assert_not_found!
      end
    end
  end
end
