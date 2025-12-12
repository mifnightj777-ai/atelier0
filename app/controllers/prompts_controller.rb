class PromptsController < ApplicationController
  def index
    @current_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
    @start_of_month = @current_date.beginning_of_month
    @end_of_month = @current_date.end_of_month
    
    start_date = @start_of_month.beginning_of_week(:monday)
    end_date = @end_of_month.end_of_week(:monday)
    
    @prompts = Prompt.where(date: start_date..end_date).index_by(&:date)
  end

  def show
    @prompt = Prompt.find(params[:id])
    @fragments = @prompt.fragments.where(visibility: :public_view).order(created_at: :desc)
  end
end