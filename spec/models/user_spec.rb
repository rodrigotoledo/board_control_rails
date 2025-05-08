# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'has_secure_password' do
    it { should have_secure_password }
  end

  it 'normalizes email before validation' do
    user = build(:user, email: '  USER@EXAMPLE.COM  ')
    user.valid?
    expect(user.email).to eq('user@example.com')
  end
end
