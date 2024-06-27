class CategoriesController < ApplicationController
  before_action :authenticate
  before_action :set_category, only: %i[show update destroy]

  # GET /categories
  def index
    category_type = all_categories_params[:category_type]
    account_categories = Category.where(account_id: logged_account.id)

    @categories = if category_type == "income"
      account_categories.income
    elsif category_type == "expense"
      account_categories.expense
    else
      account_categories.all
    end

    render json: ActiveModelSerializers::SerializableResource.new(@categories).to_json
  end

  # GET /categories/1
  def show
    render json: serialized_category
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: serialized_category, status: :created, location: @category
    else
      render json: {errors: @category.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      render json: serialized_category
    else
      render json: {errors: @category.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy!
  end

  private

  def serialized_category
    CategorySerializer.new(@category).serializable_hash
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def category_params
    include_account_id(params.require(:category).permit(:category_type, :name))
  end

  def all_categories_params
    Rails.logger.info "params #{params.permit(:category_type)}"
    include_account_id(params.permit(:category_type))
  end
end
