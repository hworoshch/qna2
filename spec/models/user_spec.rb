require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'owner?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:others_answer) { create(:answer, question: question, user: create(:user)) }
    it { expect(user).to be_owner(question) }
    it { expect(user).to_not be_owner(others_answer) }
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe 'generate_password' do
    let(:user) { User.new(email: 'user@user.com') }

    it 'generate password' do
      expect { user.generate_password }.to change(user, :password)
    end

    context 'when password generated' do
      before { user.generate_password }

      it 'password not empty' do
        expect(user.password).to_not be_empty
      end

      it 'password eq password confirmation' do
        expect(user.password).to eq user.password_confirmation
      end
    end
  end

  describe 'create_unconfirmed_authorization' do
    let!(:user) { create(:user) }
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'vk', uid: '123') }

    it 'returns the authorization' do
      expect(user.create_unconfirmed_authorization(auth)).to be_a(Authorization)
    end

    it 'create the authorization' do
      expect { user.create_unconfirmed_authorization(auth) }.to change(user.authorizations, :count).by(1)
    end

    it 'generate token' do
      expect(user.create_unconfirmed_authorization(auth).confirmation_token).to_not be_nil
    end
  end

  describe 'auth_confirmed' do
    let(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'vk', uid: '123') }
    let!(:authorization) { create(:authorization, user: user, uid: auth.uid, provider: auth.provider, confirmation_token: '88888888') }

    it 'auth not confirmed' do
      expect(user).to_not be_auth_confirmed(auth)
    end

    it 'auth confirmed' do
      authorization.confirm!
      expect(user).to be_auth_confirmed(auth)
    end
  end
end
