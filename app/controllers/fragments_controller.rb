class FragmentsController < ApplicationController
  before_action :set_fragment, only: %i[ show edit update destroy ]

  # GET /fragments or /fragments.json
  def index
    @public_fragments = Fragment.public_view.with_attached_image.includes(:user).order(created_at: :desc)

    if params[:filter] == 'teammates' && user_signed_in?
       teammate_ids = current_user.following.ids
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

    if params[:parent_id]
      @fragment.parent_id = params[:parent_id]
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fragment
      @fragment = Fragment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fragment_params
      params.require(:fragment).permit(:title, :description, :image, :visibility, :parent_id)
    end
end
