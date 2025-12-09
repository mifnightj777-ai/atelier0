class IdeasController < ApplicationController
  before_action :authenticate_user!

  layout "focus", only: [:new, :create, :edit, :update]

  def index
    @ideas = current_user.ideas.order(updated_at: :desc)
  end

  def new
    @idea = Idea.new
    @idea.visibility = :private_view
  end

  def create
    @idea = current_user.ideas.build(idea_params)
    if @idea.save
      redirect_to ideas_path, notice: "Idea stored in vault."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @idea = current_user.ideas.find(params[:id])
  end

  def update
    @idea = current_user.ideas.find(params[:id])
    if @idea.update(idea_params)
      redirect_to ideas_path, notice: "Idea updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @idea = current_user.ideas.find(params[:id])
    @idea.destroy
    redirect_to ideas_path, notice: "Idea discarded."
  end

  private

  def idea_params
    params.require(:idea).permit(:title, :description, :visibility)
  end
end