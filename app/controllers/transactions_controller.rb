class TransactionsController < ProtectedResourceController
  include TransactionHelpers

  before_action :set_transaction, only: [:destroy]

  # GET /transactions
  def index
    authorize Transaction

    @transactions = policy_scope(Transaction).all
    @transactions = @transactions.where(category_id: all_transactions_params[:category_id]) if all_transactions_params[:category_id].present?

    render_transactions @transactions, TransactionSerializer, all_transactions_params
  end

  # DELETE /transactions/1
  def destroy
    authorize @transaction
    @transaction.destroy!
  end

  private

  def all_transactions_params
    params.permit(:category_id, *shared_params)
  end

  def set_transaction
    @transaction = policy_scope(Transaction).find(params[:id])
  end
end
