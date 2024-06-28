class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.references :account, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :financial_account, null: false, foreign_key: true
      t.float :amount, default: 0.0
      t.string :description
      t.datetime :date, null: false

      t.timestamps
    end
  end
end
