class AddFinancialAccountToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_reference :transactions, :financial_account, foreign_key: true
  end
end
