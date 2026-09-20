require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { create(:user) }
  describe "ログイン機能" do
    it "正しいタイトルが表示されていること" do
      visit '/session/new'
      expect(page).to have_content("ログイン"),"ページに「ログイン」が含まれていません"
    end

    context "認証情報が正しい場合" do
      it "ログインできること" do
        visit "/session/new"
        fill_in "メールアドレス", with: user.email_address
        fill_in "パスワード", with: "password"
        click_button "ログイン"
        Capybara.assert_current_path("/", ignore_query: true)
        expect(current_path).to eq '/'
        expect(page).to have_content('ログインしました')
      end
    end

    context "PWに誤りがある場合" do
      it "ログインできないこと" do
        visit '/session/new'
        fill_in 'メールアドレス', with: user.email_address
        fill_in 'パスワード', with: "123456"
        click_button 'ログイン'
        Capybara.assert_current_path("/session/new", ignore_query: true)
        expect(current_path).to eq("/session/new"), "ログイン失敗時にログイン画面に戻ってきていません"
        expect(page).to have_content('メールアドレスまたはパスワードが違います'), "フラッシュメッセージ「メールアドレスまたはパスワードが違います」が表示されていません"
      end
    end
  end
  
  describe "ログアウト機能" do
    before do
      login_as(user)
    end
    it "ログアウトできること" do
      click_on('ログアウト', match: :first)
      Capybara.assert_current_path("/", ignore_query: true)
      expect(current_path).to eq root_path
      expect(page).to have_content('ログアウトしました')
    end
  end
end
