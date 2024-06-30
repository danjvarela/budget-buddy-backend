class FinancialAccountsController < ProtectedResourceController
  before_action :set_financial_account, only: %i[show update destroy]

  # GET /financial_accounts
  def index
    @financial_accounts = current_user.financial_accounts

    render json: ActiveModelSerializers::SerializableResource.new(@financial_accounts).to_json
  end

  # GET /financial_accounts/1
  def show
    render json: serialized_financial_account
  end

  # POST /financial_accounts
  def create
    @financial_account = current_user.financial_accounts.new(financial_account_params)

    if @financial_account.save
      render json: serialized_financial_account, status: :created
    else
      render json: {errors: @financial_account.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /financial_accounts/1
  def update
    if @financial_account.update(financial_account_params)
      render json: serialized_financial_account
    else
      render json: @financial_account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /financial_accounts/1
  def destroy
    @financial_account.destroy!
  end

  private

  def serialized_financial_account
    ActiveModelSerializers::SerializableResource.new(@financial_account).serializable_hash
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_financial_account
    @financial_account = FinancialAccount.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def financial_account_params
    params.require(:financial_account).permit(:name, :description, :initial_amount)
  end
end
