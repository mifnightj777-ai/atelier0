class FragmentsController < ApplicationController
  before_action :set_fragment, only: %i[ show edit update destroy ]

  # GET /fragments or /fragments.json
  def index
    @public_fragments = Fragment.public_view.with_attached_image.includes(:user).order(created_at: :desc)
    @daily_prompt = Prompt.find_by(date: Date.today)

    if params[:filter] == 'teammates' && user_signed_in?
       teammate_ids = (current_user.following.ids + current_user.followers.ids).uniq
       
       @fragments = Fragment.where(user_id: teammate_ids)
                           .where(visibility: [:public_view, :teammates_view])
                           .with_attached_image.includes(:user)
                           .order(created_at: :desc)
    else
      @fragments = @public_fragments
    end
  end

  # GET /fragments/1 or /fragments/1.json
  def show
  end

  # GET /fragments/new
  def new
    @fragment = Fragment.new
    @show_tutorial = current_user.fragments.empty?

    if params[:parent_id]
      @fragment.parent_id = params[:parent_id]
    end

    if params[:prompt_id]
      @fragment.prompt_id = params[:prompt_id]
    end
  end

  # GET /fragments/1/edit
  def edit
  end

  # POST /fragments or /fragments.json
  def create
    @fragment = current_user.fragments.build(fragment_params)

    respond_to do |format|
      if @fragment.save
        format.html { redirect_to @fragment, notice: "Fragment was successfully created." }
        format.json { render :show, status: :created, location: @fragment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fragment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fragments/1 or /fragments/1.json
  def update
    respond_to do |format|
      if @fragment.update(fragment_params)
        format.html { redirect_to @fragment, notice: "Fragment was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @fragment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fragment.errors, status: :unprocessable_entity }
      end
    end
  end

  def timeline
    @fragment = Fragment.find(params[:id])
    @root = @fragment.root || @fragment
    @current_fragment_id = @fragment.id
  end

  # DELETE /fragments/1 or /fragments/1.json
  def destroy
    @fragment.destroy!

    respond_to do |format|
      format.html { redirect_to fragments_path, notice: "Fragment was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def gallery
    @fragments = Fragment.where.not(prompt_id: nil)
                         .where(visibility: :public_view) 
                         .order(created_at: :desc)
    Rails.logger.info "GALLERY DEBUG: 取得された作品数: #{@fragments.count}"
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fragment
      @fragment = Fragment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fragment_params
      params.require(:fragment).permit(:title, :description, :image, :audio, :visibility, :parent_id, :prompt_id)
    end
end
