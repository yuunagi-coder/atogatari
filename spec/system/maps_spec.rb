require 'rails_helper'

RSpec.describe "Maps", type: :system, js: true do
  let(:user1){ create(:user, name: 'テスト１') }
  let(:user2){ create(:user, name: 'テスト２') }
  let(:record1) { create(:record, user: user1, spot_name: '東京駅', latitude: 35.68098, longitude: 139.767057, memo: '美しい', recorded_at: '2026/09/25 06:23')}
  let(:record2) { create(:record, user: user1, spot_name: 'スカイツリー', latitude: 35.709994, longitude: 139.80865, memo: '楽しい', recorded_at: '2026/09/24 06:23')}
  let(:record3) { create(:record, user: user2, spot_name: '有楽町駅', latitude: 35.675013, longitude: 139.76302, memo: 'わくわく', recorded_at: '2026/09/23 11:00')}

  describe 'マップ機能' do
    context 'ログインしていない場合' do
      it 'トップページにリダイレクトされること' do
        visit '/'
        expect(page).to have_content("場所と思い出をつなぐお出かけログ"),'ログイン前のトップページに遷移していません'
      end
    end

    context 'ログインしている場合' do
      it 'マップが表示されること' do
        login_as(user1)
        visit '/'
        expect(page).to have_css('.gm-style', wait: 10)
        expect(page).to have_css('.gm-style img', wait: 10)
        map_height = page.evaluate_script("document.getElementById('map').offsetHeight")
        expect(map_height).to be > 0
      end
    end

    describe 'マーカー表示' do
      context '記録がある場合' do
        before do
          user1
          user2
          record1
          record2
          record3
          login_as(user1)
        end
        it '自分のマーカーのみ表示されること' do
          visit '/'
          expect(page).to have_css('gmp-advanced-marker[title="東京駅"]', wait: 10),'ログインしたユーザーの記録が表示されていません'
          expect(page).not_to have_css('gmp-advanced-marker[title="有楽町駅"]'),'他のユーザーの記録が表示されています'
        end
        it 'マーカーをクリックするとモーダルが表示されること' do
          visit '/'
          find('gmp-advanced-marker[title="東京駅"]', wait: 10).click
          expect(page).to have_selector('#markerModal'),'モーダルが表示されていません'
          expect(find('#modal_spot_name')).to have_content(record1.spot_name),'モーダルに正しい情報が表示されていません'
          
          click_button("×")
          expect(page).not_to have_selector('#markerModal'),'モーダルを閉じていません'
          
          find('gmp-advanced-marker[title="スカイツリー"]').click
          expect(page).to have_selector('#markerModal'),'モーダルが表示されていません'
          expect(find('#modal_spot_name')).to have_content(record2.spot_name),'モーダルに正しい情報が表示されていません'
        end
      end

      context '記録がない場合' do
        it 'マップにマーカーが表示されないこと' do
          user1
          login_as(user1)
          expect(page).not_to have_css('gmp-advanced-marker', wait: 10),'記録が１件もない場合にマーカーが表示されています'
        end
      end
    end
  end
end
