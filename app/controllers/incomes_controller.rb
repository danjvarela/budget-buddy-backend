class IncomesController < ProtectedResourceController
  before_action :set_income, only: [:show, :update, :destroy]

  def index
    authorize Transaction

    @incomes = policy_scope(Transaction).income

    render json: ActiveModelSerializers::SerializableResource.new(@incomes).serializable_hash
  end

  def create
    authorize Transaction

    @income = policy_scope(Transaction).new({**income_params, transaction_type: "income"})

    if @income.save
      render json: serialized_income, status: :created
    else
      render json: {errors: @income.errors}, status: :unprocessable_entity
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
      render json: @income.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @income
    @income.destroy!
  end

  private

  def serialized_income
    ActiveModelSerializers::SerializableResource.new(@income).serializable_hash
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_income
    @income = policy_scope(Transaction).find(params[:id])
  end

  def income_params
    params.require(:income).permit(:category_id, :financial_account_id, :date, :amount, :description)
  end
end
