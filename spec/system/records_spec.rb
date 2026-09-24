require 'rails_helper'

RSpec.describe "Records", type: :system do
  let(:user){ create(:user) }
  let(:record){ create(:record, user: user) }

  describe '記録のCRUD' do
    describe '記録一覧' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit '/records'
          Capybara.assert_current_path("/session/new", ignore_query: true)
          expect(current_path).to eq('/session/new'),'ログインページにリダイレクトされていません'
        end
      end

      context 'ログインしている場合' do
        it 'ナビバーのリンクから記録一覧へ遷移できること' do
          login_as(user)
          click_on('記録一覧', match: :first)
          Capybara.assert_current_path("/records", ignore_query: true)
          expect(current_path).to eq('/records'),'ナビバーのリンクから記録一覧画面に遷移できません'
        end

        it '正しいタイトルが表示されていること' do
          login_as(user)
          click_on('記録一覧', match: :first)
          expect(page).to have_content("記録一覧"),'「記録一覧」がページ内に含まれていません'
        end
      end

      context '記録が一件もない場合' do
        it '何もない旨のメッセージが表示されること' do
          login_as(user)
          click_on('記録一覧', match: :first)
          expect(page).to have_content("思い出が記録されていないようです"),'記録が一件もない場合何もない旨のメッセージが表示されていません'
        end
      end

      context '記録がある場合' do
        it '記録の一覧が表示されること' do
          record
          login_as(user)
          click_on('記録一覧', match: :first)
          expect(page).to have_content(record.spot_name), '記録一覧画面に記録のタイトルが表示されていません'
          expect(page).to have_content(record.memo),'記録一覧画面に記録のメモが表示されていません'
          expect(page).to have_content(record.recorded_at.strftime("%Y年%m月%d日")),'記録一覧画面に記録の行った日が表示されていません'
        end
      end
      
      context '記録が４件以下の場合' do
        let!(:records){ create_list(:record, 4, user: user) }
        it 'ページングが表示されないこと' do
          login_as(user)
          visit records_path
          expect(page).not_to have_selector('.pagination'),'記録が４件以下の場合ページングが表示されています'
        end
      end

      context '記録が５件以上の場合' do
        let!(:records){ create_list(:record, 5, user: user) }
        it 'ページングが表示されること' do
          login_as(user)
          visit records_path
          expect(page).to have_selector('.pagination'),'記録が５件以上の場合ページングが表示されていません'
        end
      end
    end
    
    describe '記録の詳細' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit record_path(record)
          Capybara.assert_current_path("/session/new", ignore_query: true)
          expect(current_path).to eq('/session/new'),'ログインページにリダイレクトされていません'
        end
      end

      context 'ログインしている場合' do
        before do
          record
          login_as(user)
        end
        it '記録一覧から記録へ遷移できること' do
          click_on('記録一覧', match: :first)
          click_on(record.spot_name)
          Capybara.assert_current_path("/records/#{record.id}", ignore_query: true)
          expect(current_path).to eq("/records/#{record.id}"),'記録詳細画面に遷移できません'
          expect(page).to have_content(record.spot_name), '記録一覧画面に記録のタイトルが表示されていません'
          expect(page).to have_content(record.memo),'記録詳細画面に記録のメモが表示されていません'
          expect(page).to have_content(record.recorded_at.strftime("%Y年%m月%d日")),'記録詳細画面に記録の行った日が表示されていません'
        end

        it '正しいタイトルが表示されていること' do
          click_on('記録一覧', match: :first)
          click_on(record.spot_name)
          expect(page).to have_content("記録詳細"),'「記録詳細」がページ内に含まれていません'
        end
      end
    end

    describe '記録の作成' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit 'records/new'
          Capybara.assert_current_path('/session/new', ignore_query: true)
          expect(current_path).to eq('/session/new'),'ログインしていない場合、記録作成するとログインページにリダイレクトされません'
        end
      end

      context 'ログインしている場合' do
        before do
          login_as(user)
          click_on('記録する', match: :first)
        end

        it '正しいタイトルが表示されていること' do
          expect(page).to have_content('記録する'),'「記録する」がページ内に含まれていません'
        end

        it '記録が作成できること' do
          fill_in '場所名', with: 'テスト場所名'
          fill_in '緯度', with: 35.68098
          fill_in '経度', with: 139.767057
          fill_in '訪れた日時', with: '2026/09/24 19:35'
          fill_in 'メモ', with: 'テストメモ'
          file_path = Rails.root.join('app','assets','images','default_image.jpg')
          attach_file '写真', file_path
          click_button '登録する'
          Capybara.assert_current_path("/", ignore_query: true)
          expect(current_path).to eq('/'), '記録一覧画面に遷移していません'
          expect(page).to have_content('記録を作成しました'), 'フラッシュメッセージ「記録を作成しました」が表示されていません'
        end

        it '記録の作成に失敗すること' do
          fill_in '場所名', with: 'テスト場所名'
          file_path = Rails.root.join('app','assets','images','default_image.jpg')
          attach_file '写真', file_path
          click_button '登録する'
          expect(page).to have_content('件のエラーがあります'), 'エラーメッセージ「件のエラーがあります」が表示されていません'
          expect(page).to have_content('緯度を入力してください'), 'エラーメッセージが表示されません'
        end
      end
    end
  end
end
