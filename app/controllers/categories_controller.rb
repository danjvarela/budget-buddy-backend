class CategoriesController < ProtectedResourceController
  before_action :set_category, only: %i[show update destroy]

  # GET /categories
  def index
    category_type = all_categories_params[:category_type]

    @categories = if category_type == "income"
      logged_account.categories.income
    elsif category_type == "expense"
      logged_account.categories.expense
    else
      logged_account.categories.all
    end

    render json: ActiveModelSerializers::SerializableResource.new(@categories).to_json
  end

  # GET /categories/1
  def show
    render json: serialized_category
  end

  # POST /categories
  def create
    @category = logged_account.categories.new(category_params)

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
    params.require(:category).permit(:category_type, :name)
  end

  def all_categories_params
    params.permit(:category_type)
  end
end
