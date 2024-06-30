class TransfersController < ProtectedResourceController
  before_action :set_transfer, only: [:show, :update, :destroy]

  def index
    authorize Transaction

    @transfers = policy_scope(Transaction).transfer

    render json: ActiveModelSerializers::SerializableResource.new(@transfers).serializable_hash
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
    ActiveModelSerializers::SerializableResource.new(@transfer).serializable_hash
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_transfer
    @transfer = policy_scope(Transaction).find(params[:id])
  end

  def transfer_params
    params.require(:transfer).permit(:from_financial_account_id, :to_financial_account_id, :date, :amount, :description)
  end
end
