class TransactionsController < ProtectedResourceController
  before_action :set_transaction, only: [:destroy]

  # GET /transactions
  def index
    @transactions = current_user.transactions

    render json: ActiveModelSerializers::SerializableResource.new(@transactions).serializable_hash
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy!
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
end
