class Villa < ApplicationRecord
  has_many :calendar_entries, dependent: :destroy

  def self.search_results(start_date, end_date, sort_by)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    villas = Villa.joins(:calendar_entries)
      .where(calendar_entries: { date: start_date...end_date })
      .group('villas.id')
      .select('villas.*,
              AVG(calendar_entries.price) AS average_price,
              SUM(calendar_entries.price) * 1.18 AS total_price_with_gst')

    villas = villas.map do |villa|
      {
        id: villa.id,
        name: villa.name,
        description: villa.description,
        average_price_per_night: villa.average_price&.round(2),
        total_price_with_gst: villa.total_price_with_gst&.round(2),
        availability: villa.available_for_dates?(start_date, end_date),
        start_date: start_date,
        end_date: end_date
      }
    end

    sort_villas(villas, sort_by)
  end

  def available_for_dates?(start_date, end_date)
    entries = calendar_entries.where(date: start_date...end_date)

    if entries.count == (end_date - start_date).to_i
      entries[0...-1].all?(&:available) || (entries[0...-1].all?(&:available) && !entries.last.available)
    else
      false
    end
  end

  private

  def self.sort_villas(villas, sort_by)
    if sort_by.eql? 'availability'
      villas.sort_by! { |villa| [villa[:availability] ? 0 : 1, villa[:average_price_per_night]] }
    else
      villas.sort_by! { |villa| villa[:average_price_per_night] }
    end
  end
end
