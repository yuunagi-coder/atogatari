module SystemHelper
  def login_as(user)
    visit root_path
    click_link "ログイン"
    fill_in 'メールアドレス', with: user.email_address
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    Capybara.assert_current_path("/", ignore_query: true)
  end
end

RSpec.configure do |config|
  config.include SystemHelper, type: :system
end

