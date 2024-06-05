require 'rails_helper'

RSpec.describe Villa, type: :model do
  describe '.search_results' do
    let(:start_date) { Date.today.to_s }
    let(:end_date) { (Date.today + 7).to_s }
    let!(:villa1) { create(:villa, name: 'Villa One') }
    let!(:villa2) { create(:villa, name: 'Villa Two') }

    before do
      create(:calendar_entry, villa: villa1, date: Date.parse(start_date), price: 100, available: true)
      create(:calendar_entry, villa: villa1, date: Date.parse(end_date) - 1, price: 100, available: true)
      create(:calendar_entry, villa: villa2, date: Date.parse(start_date), price: 200, available: false)
      create(:calendar_entry, villa: villa2, date: Date.parse(end_date) - 1, price: 200, available: true)
    end

    it 'returns sorted villas by availability' do
      sorted_villas = Villa.search_results(start_date, end_date, 'availability')
      expect(sorted_villas.first[:name]).to eq('Villa One') # The result is expected to be 'Villa One'
      expect(sorted_villas.last[:name]).to eq('Villa Two')  # The result is expected to be 'Villa Two'
    end
  end

  describe '#available_for_dates?' do
    let(:villa) { create(:villa) }
    let(:start_date) { Date.today.to_s }
    let(:end_date) { (Date.today + 7).to_s }

    before do
      (Date.parse(start_date)...Date.parse(end_date)).each do |date|
        create(:calendar_entry, villa: villa, date: date, available: true)
      end
    end

    it 'returns true if villa is available for all dates' do
      expect(villa.available_for_dates?(Date.parse(start_date), Date.parse(end_date))).to be_truthy
    end

    it 'returns false if villa is not available for any date' do
      create(:calendar_entry, villa: villa, date: Date.parse(end_date) - 1, available: false)
      expect(villa.available_for_dates?(Date.parse(start_date), Date.parse(end_date))).to be_falsey
    end
  end
end
