class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :transaction_type, null: false
      t.references :account, null: false, foreign_key: true
      t.references :category, foreign_key: true
      t.references :from_financial_account, foreign_key: {to_table: :financial_accounts}
      t.references :to_financial_account, foreign_key: {to_table: :financial_accounts}
      t.datetime :date, null: false
      t.float :amount, default: 0.0
      t.string :description

      t.timestamps
    end
  end
end
