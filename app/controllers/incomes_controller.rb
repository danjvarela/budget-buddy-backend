class IncomesController < ProtectedResourceController
  include TransactionHelpers

  before_action :set_income, only: [:show, :update, :destroy]

  def index
    authorize Transaction

    @incomes = policy_scope(Transaction).income
    @incomes = @incomes.where(category_id: all_incomes_params[:category_id]) if all_incomes_params[:category_id].present?
    @incomes = @incomes.where(financial_account_id: all_incomes_params[:financial_account_id]) if all_incomes_params[:financial_account_id].present?

    render_transactions @incomes, IncomeSerializer, all_incomes_params
  end

  def create
    authorize Transaction

    @income = policy_scope(Transaction).new({**income_params, transaction_type: "income"})

    if @income.save
      render json: serialized_income, status: :created
    else
      render json: camelize_keys({errors: @income.errors.to_hash}), status: :unprocessable_entity
    end
  end

  def show
    authorize @income
    render json: serialized_income
  end

  def update
    authorize @income
    if @income.update(income_params)
      render json: serialized_income
    else
      render json: camelize_keys({errors: @income.errors.to_hash}), status: :unprocessable_entity
    end
  end

  def destroy
    authorize @income
    @income.destroy!
  end

  private

  def serialized_income
    ActiveModelSerializers::SerializableResource.new(@income, serializer: IncomeSerializer).serializable_hash
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_income
    @income = policy_scope(Transaction).income.find(params[:id])
  end

  def income_params
    params.require(:income).permit(:category_id, :financial_account_id, :date, :amount, :description)
  end

  def all_incomes_params
    params.permit(:category_id, :financial_account_id, *shared_params)
  end
end
