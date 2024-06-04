class Api::V1::VillasController < ApplicationController

  def index
    start_date, end_date, sort_by = params.values_at(:start_date, :end_date, :sort_by)
    sort_by ||= 'availability'

    if valid_dates?(start_date, end_date)
      villas = Villa.search_results(start_date, end_date, sort_by)
      render json: villas, status: :ok
    else
      render json: { error: 'Invalid or missing date parameters' }, status: :bad_request
    end
  end

  private

  def valid_dates?(start_date, end_date)
    [start_date, end_date].all? { |date| date.present? && Date.parse(date) rescue false }
  end
end
