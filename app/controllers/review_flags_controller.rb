class ReviewFlagsController < ApplicationController
  before_action :set_review_flag, only: [:show, :edit, :update, :destroy]

  # GET /review_flags
  # GET /review_flags.json
  def index
    @review_flags = ReviewFlag.all
  end

  # GET /review_flags/1
  # GET /review_flags/1.json
  def show
  end

  # GET /review_flags/new
  def new
    @review_flag = ReviewFlag.new
  end

  # GET /review_flags/1/edit
  def edit
  end

  # POST /review_flags
  # POST /review_flags.json
  def create
    @review_flag = ReviewFlag.new(review_flag_params)
    respond_to do |format|
      if @review_flag.save
        format.html { redirect_to :back, notice: 'Review has been flagged successfully. we will review the flagged post and reply back to you with a decision.' }
        format.json { render :show, status: :created, location: @review_flag }
      else
        format.html { render :new }
        format.json { render json: @review_flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /review_flags/1
  # PATCH/PUT /review_flags/1.json
  def update
    respond_to do |format|
      if @review_flag.update(review_flag_params)
        format.html { redirect_to @review_flag, notice: 'Review flag was successfully updated.' }
        format.json { render :show, status: :ok, location: @review_flag }
      else
        format.html { render :edit }
        format.json { render json: @review_flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /review_flags/1
  # DELETE /review_flags/1.json
  def destroy
    @review_flag.destroy
    respond_to do |format|
      format.html { redirect_to review_flags_url, notice: 'Review flag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review_flag
      @review_flag = ReviewFlag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_flag_params
      params.require(:review_flag).permit(:review_id, :user_id, :flag_description)
    end
end
