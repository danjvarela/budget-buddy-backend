class ExpensesController < ProtectedResourceController
  before_action :set_expense, only: %i[show update destroy]

  # GET /expenses
  def index
    @expenses = Expense.all

    render json: ActiveModelSerializers::SerializableResource.new(@expenses).to_json
  end

  # GET /expenses/1
  def show
    render json: serialized_expense
  end

  # POST /expenses
  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      render json: serialized_expense, status: :created, location: @expense
    else
      render json: {errors: @expense.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /expenses/1
  def update
    if @expense.update(expense_params)
      render json: serialized_expense
    else
      render json: {errors: @expense.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /expenses/1
  def destroy
    @expense.destroy!
  end

  private

  def serialized_expense
    ExpenseSerializer.new(@expense).serializable_hash
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_expense
    @expense = Expense.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def expense_params
    include_account_id(params.require(:expense).permit(:category_id, :financial_account_id, :amount, :description, :date))
  end
end
