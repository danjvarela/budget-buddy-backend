class ChangeFinancialAccountAmountToInitialAmount < ActiveRecord::Migration[7.1]
  def change
    rename_column :financial_accounts, :amount, :initial_amount
  end
end
