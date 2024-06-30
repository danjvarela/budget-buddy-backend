class ExpensesController < ProtectedResourceController
  before_action :set_expense, only: [:show, :update, :destroy]

  def index
    @expenses = logged_account.transactions.expense

    render json: ActiveModelSerializers::SerializableResource.new(@expenses).serializable_hash
  end

  def create
    @expense = logged_account.transactions.new({**expense_params, transaction_type: "expense"})

    if @expense.save
      render json: serialized_expense, status: :created
    else
      render json: {errors: @expense.errors}, status: :unprocessable_entity
    end
  end

  def show
    render json: serialized_expense
  end

  def update
    if @expense.update(expense_params)
      render json: serialized_expense
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy!
  end

  private

  def serialized_expense
    ActiveModelSerializers::SerializableResource.new(@expense).serializable_hash
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_expense
    @expense = Transaction.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:category_id, :financial_account_id, :date, :amount, :description)
  end
end
