class ExpensesController < ProtectedResourceController
  include TransactionFilters

  before_action :set_expense, only: [:show, :update, :destroy]

  def index
    authorize Transaction

    @expenses = policy_scope(Transaction).expense
    @expenses = @expenses.where(category_id: all_expenses_params[:category_id]) if all_expenses_params[:category_id].present?
    @expenses = @expenses.where(financial_account_id: all_expenses_params[:financial_account_id]) if all_expenses_params[:financial_account_id].present?
    @expenses = filter_transactions @expenses

    data = ActiveModelSerializers::SerializableResource.new(@expenses, each_serializer: ExpenseSerializer, include_pagination_data: true).serializable_hash

    render json: {
      **pagination_data(@expenses),
      **data
    }
  end

  def create
    authorize Transaction

    @expense = policy_scope(Transaction).new({**expense_params, transaction_type: "expense"})

    if @expense.save
      render json: serialized_expense, status: :created
    else
      render json: camelize_keys({errors: @expense.errors.to_hash}), status: :unprocessable_entity
    end
  end

  def show
    authorize @expense
    render json: serialized_expense
  end

  def update
    authorize @expense
    if @expense.update(expense_params)
      render json: serialized_expense
    else
      render json: camelize_keys({errors: @expense.errors.to_hash}), status: :unprocessable_entity
    end
  end

  def destroy
    authorize @expense
    @expense.destroy!
  end

  private

  def serialized_expense
    ActiveModelSerializers::SerializableResource.new(@expense, serializer: ExpenseSerializer).serializable_hash
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_expense
    @expense = policy_scope(Transaction).expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:category_id, :financial_account_id, :date, :amount, :description)
  end

  def all_expenses_params
    params.permit(:category_id, :financial_account_id)
  end
end
