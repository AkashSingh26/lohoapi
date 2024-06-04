class Api::V1::VillasController < ApplicationController
  def index
    start_date = params[:start_date]
    end_date = params[:end_date]
    guest = params[:guest] # For future filtering (not used in this implementation)

    # Basic parameter checks
    if start_date.blank? || end_date.blank?
      render json: { error: 'Start date and end date are required' }, status: :bad_request
      return
    end

    # Optimized query using joins and case statement for availability
    villas = Villa.joins(:calendar_entries)
                  .where(calendar_entries: { date: start_date..end_date })
                  .select('villas.id AS id, villas.name AS name, villas.description AS description, villas.guest AS guest_count,
                          AVG(calendar_entries.price) AS average_price,
                          SUM(calendar_entries.price) * 1.18 AS total_price_with_gst,
                          CASE WHEN MIN(calendar_entries.available) THEN true ELSE false END AS available')
                  .group('villas.id')
                  .order('available DESC, average_price DESC')

    # Transform data to desired structure
    villas_data = villas.map do |villa|

      {
        start_date: start_date,
        end_date: end_date,
        name: villa.name,
        description: villa.description,
        guest_count: villa.guest_count,
        average_price: villa.average_price,
        total_price_with_gst: villa.total_price_with_gst.round(2),
        available: villa.available
      }
    end

    render json: villas_data
  end
end
