class TransfersController < ProtectedResourceController
  include TransactionHelpers

  before_action :set_transfer, only: [:show, :update, :destroy]

  def index
    authorize Transaction

    @transfers = policy_scope(Transaction).transfer

    @transfers = @transfers.where from_financial_account_id: all_transfers_params[:from_financial_account_id] if all_transfers_params[:from_financial_account_id].present?
    @transfers = @transfers.where to_financial_account_id: all_transfers_params[:to_financial_account_id] if all_transfers_params[:to_financial_account_id].present?
    
    render_transactions @transfers, TransferSerializer, all_transfers_params
  end

  def create
    authorize Transaction

    @transfer = policy_scope(Transaction).new({**transfer_params, transaction_type: "transfer"})

    if @transfer.save
      render json: serialized_transfer, status: :created
    else
      render json: camelize_keys({errors: @transfer.errors.to_hash}), status: :unprocessable_entity
    end
  end

  def show
    authorize @transfer
    render json: serialized_transfer
  end

  def update
    authorize @transfer
    if @transfer.update(transfer_params)
      render json: serialized_transfer
    else
      render json: camelize_keys({errors: @transfer.errors.to_hash}), status: :unprocessable_entity
    end
  end

  def destroy
    authorize @transfer
    @transfer.destroy!
  end

  private

  def serialized_transfer
    ActiveModelSerializers::SerializableResource.new(@transfer, serializer: TransferSerializer).serializable_hash
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_transfer
    @transfer = policy_scope(Transaction).transfer.find(params[:id])
  end

  def transfer_params
    params.require(:transfer).permit(:from_financial_account_id, :to_financial_account_id, :date, :amount, :description)
  end

  def all_transfers_params
    params.permit(:from_financial_account_id, :to_financial_account_id, *shared_params)
  end
end
