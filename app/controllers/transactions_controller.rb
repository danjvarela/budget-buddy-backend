class TransactionsController < ProtectedResourceController
  before_action :set_transaction, only: [:destroy]

  # GET /transactions
  def index
    authorize Transaction

    @transactions = policy_scope(Transaction).all

    render json: ActiveModelSerializers::SerializableResource.new(@transactions).serializable_hash
  end

  # DELETE /transactions/1
  def destroy
    authorize @transaction
    @transaction.destroy!
  end

  private

  def set_transaction
    @transaction = policy_scope(Transaction).find(params[:id])
  end
end
