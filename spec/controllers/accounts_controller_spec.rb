require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @accounts" do
      get :index
      expect(assigns(:accounts)).to eq([account])
    end

    it "assigns @friends" do
      get :index
      expect(assigns(:friends)).to eq(user.account.friends.pluck(:id))
    end

    it "assigns @sent_friend_requests" do
      get :index
      expect(assigns(:sent_friend_requests)).to eq(user.account.sent_friend_requests.pluck(:friend_id))
    end

    it "assigns @received_friend_requests" do
      get :index
      expect(assigns(:received_friend_requests)).to eq(user.account.received_friend_requests.pluck(:account_id))
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: account.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: account.to_param }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:new_attributes) {
        { first_name: "NewFirstName" }
      }

      it "updates the requested account" do
        patch :update, params: { id: account.to_param, account: new_attributes }
        account.reload
        expect(account.first_name).to eq("NewFirstName")
      end

      it "redirects to the account" do
        patch :update, params: { id: account.to_param, account: new_attributes }
        expect(response).to redirect_to(account)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        patch :update, params: { id: account.to_param, account: { first_name: nil } }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested account" do
      account_to_destroy = create(:account, user: user)
      expect {
        delete :destroy, params: { id: account_to_destroy.to_param }
      }.to change(Account, :count).by(-1)
    end

    it "redirects to the accounts list" do
      delete :destroy, params: { id: account.to_param }
      expect(response).to redirect_to(accounts_url)
    end
  end
end