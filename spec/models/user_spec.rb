require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザーのバリデーションに関するテスト' do
    it 'ユーザー名、メールアドレス、パスワードがある場合は有効' do
      valid_user = FactoryBot.build(:user)
      expect(valid_user).to be_valid
    end
    
    it 'ユーザー名が空白の場合は無効' do
      user_without_name = FactoryBot.build(:user, name: '')
      expect(user_without_name).to be_invalid
    end

    it 'ユーザー名が31文字を超える場合は無効' do
      user_more_than_name = FactoryBot.build(:user, name: 'a' * 31)
      expect(user_more_than_name).to be_invalid
    end

    it 'メールアドレスが空白の場合は無効' do
      user_without_email_address = FactoryBot.build(:user, email_address: '')
      expect(user_without_email_address).to be_invalid
    end

    it '同じメールアドレスが既に登録されている場合は無効' do
      user = FactoryBot.create(:user)
      user_duplicate_email_address = FactoryBot.build(:user, email_address: user.email_address)
      expect(user_duplicate_email_address).to be_invalid
    end

    it 'パスワードがない場合は無効' do
      user_without_password = FactoryBot.build(:user, password: '')
      expect(user_without_password).to be_invalid
    end

    it 'パスワード(確認用)とパスワードが一致しない場合は無効' do
      user_password_mismatch = FactoryBot.build(:user, password_confirmation: 'mismatch')
      expect(user_password_mismatch).to be_invalid
    end
  end
end
