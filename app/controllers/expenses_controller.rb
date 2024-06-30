class ExpensesController < ProtectedResourceController
  before_action :set_expense, only: [:show, :update, :destroy]

  def index
    authorize Transaction

    @expenses = policy_scope(Transaction).expense

    render json: ActiveModelSerializers::SerializableResource.new(@expenses).serializable_hash
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
    ActiveModelSerializers::SerializableResource.new(@expense).serializable_hash
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_expense
    @expense = policy_scope(Transaction).find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:category_id, :financial_account_id, :date, :amount, :description)
  end
end
