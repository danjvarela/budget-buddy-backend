class CreateFinancialAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :financial_accounts do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.float :amount, null: false

      t.timestamps
    end
  end
end
