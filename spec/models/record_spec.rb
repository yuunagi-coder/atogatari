require 'rails_helper'

RSpec.describe Record, type: :model do
  describe 'レコードモデルのバリデーションに関するテスト' do
    it '場所名、緯度経度、行った日時がある場合、有効' do
      valid_record = FactoryBot.build(:record)
      expect(valid_record).to be_valid
    end

    it '場所名が空白の場合は無効' do
      record_without_spot_name = FactoryBot.build(:record, spot_name: "")
      expect(record_without_spot_name).to be_invalid
    end

    it '場所名が31字以上の場合は無効' do
      record_more_than_spot_name = FactoryBot.build(:record, spot_name: "a"*31 )
      expect(record_more_than_spot_name).to be_invalid
    end

    it '経度が空白の場合は無効' do
      record_without_longitude = FactoryBot.build(:record, longitude: "")
      expect(record_without_longitude).to be_invalid
    end

    it '緯度が空白の場合は無効' do
      record_without_latitude = FactoryBot.build(:record, latitude: "")
      expect(record_without_latitude).to be_invalid
    end

    it '行った日時が空白の場合は無効' do
      record_without_recorded_at = FactoryBot.build(:record, recorded_at: "")
      expect(record_without_recorded_at).to be_invalid
    end
  end

  describe 'レコードモデルのアソシエーションに関するテスト' do
    it 'userに紐づいていること' do
      user = FactoryBot.create(:user)
      record = FactoryBot.build(:record, user: user)
      expect(record.user).to eq(user)
    end
  end
end
