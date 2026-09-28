require 'rails_helper'

RSpec.describe "検索機能", type: :system do
  let(:user) { create(:user) }
  let(:record1) { create(:record, user: user, spot_name: '東京駅', memo: '美しい', recorded_at: '2026/09/25 06:23')}
  let(:record2) { create(:record, user: user, spot_name: 'ディズニーランド', memo: '楽しい', recorded_at: '2026/09/24 06:23')}
  let(:record3) { create(:record, user: user, spot_name: '有楽町駅', memo: 'わくわく', recorded_at: '2026/09/23 11:00')}

  describe '記録一覧画面での検索' do
    before do
      login_as(user)
      record1
      record2
      visit records_path
    end
    context '検索条件に該当する記録がある場合' do
      describe 'タイトルでの検索機能の検証' do
        it '該当する記録のみ表示されること' do
          fill_in 'q_spot_name_or_memo_cont', with: '東京駅'
          click_on '検索'
          Capybara.assert_current_path("/records", ignore_query: true)
          expect(current_path).to eq(records_path),'記録一覧でないページに遷移しています'
          expect(page).to have_content(record1.spot_name),'記録タイトルでの検索機能が正しく機能していません'
          expect(page).not_to have_content(record2.spot_name),'記録タイトルでの検索機能が正しく機能していません'
        end
      end

      describe 'メモでの検索機能の検証' do
        it '該当する記録のみ表示されること' do
          fill_in 'q_spot_name_or_memo_cont', with: '美しい'
          click_on '検索'
          Capybara.assert_current_path("/records", ignore_query: true)
          expect(current_path).to eq(records_path), '記録一覧でないページに遷移しています'
          expect(page).to have_content(record1.spot_name), '記録メモでの検索機能が正しく機能していません'
          expect(page).not_to have_content(record2.spot_name), '記録メモでの検索機能が正しく機能していません'
        end
      end

      describe '訪れた日時での検索機能の検証' do
        it '該当する記録のみ表示されること' do
          fill_in 'q_recorded_at_gteq', with: '2026/09/25'
          fill_in 'q_recorded_at_lteq_end_of_day', with: '2026/09/25'
          click_on '検索'
          Capybara.assert_current_path("/records", ignore_query: true)
          expect(current_path).to eq(records_path), '記録一覧でないページに遷移しています'
          expect(page).to have_content(record1.spot_name), '記録日時での検索機能が正しく機能していません'
          expect(page).not_to have_content(record2.spot_name), '記録日時での検索機能が正しく機能していません'
        end
      end
    end

    context '検索条件に該当する記録がない場合' do
      it '1件もない旨のメッセージが表示されること' do
        fill_in 'q_spot_name_or_memo_cont', with: 'ヒットなし'
        click_on '検索'
        Capybara.assert_current_path("/records", ignore_query: true)
        expect(current_path).to eq(records_path), '記録一覧でないページに遷移しています'
        expect(page).to have_content('思い出が記録されていないようです'), '１件もヒットしない場合「思い出が記録されていないようです」というメッセージが表示されていません'
      end
    end
  end
end
