require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system do
  it '正しいタイトルが表示されていること' do
    visit '/user/new'
    expect(page).to have_content('新規登録'),'タイトルに「新規登録」が表示されていません'
  end

  context "入力情報正常系" do
    it "ユーザーが新規作成できること" do
      visit '/user/new'
      expect {
        fill_in 'ユーザー名', with: 'テスト'
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録する'
        Capybara.assert_current_path("/session/new", ignore_query: true)
      }.to change { User.count }.by(1)
      expect(page).to have_content('ユーザーの新規登録に成功しました'),'フラッシュメッセージ「ユーザーの新規登録に成功しました」が表示されていません'
    end

    # it "ユーザーが登録情報を更新できること" do

    # end
  end

  context "入力情報異常系" do
    it "ユーザーが新規登録できない" do
      visit '/user/new'
      expect {
        fill_in 'メールアドレス', with: 'example@example.com'
        click_button '登録する'
      }.to change { User.count }.by(0)
      expect(page).to have_content('件のエラーがあります'),'エラーメッセージ「件のエラーがあります」が表示されていません'
      expect(page).to have_content('ユーザー名を入力してください'),'エラーメッセージ「ユーザー名を入力してください」が表示されていません'
      expect(page).to have_content('パスワードを入力してください'),'エラーメッセージ「パスワードを入力してください」が表示されていません'
      expect(page).to have_content('パスワード確認を入力してください'),'エラーメッセージ「パスワード確認を入力してください」が表示されていません'
    end

    # it "ユーザー登録情報を更新できない" do
    # end
  end
end
