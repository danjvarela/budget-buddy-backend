require "rails_helper"

RSpec.describe Transaction, type: :model do
  context "associations" do
    it { should belong_to(:account) }
    it { should belong_to(:category).optional }
    it { should belong_to(:financial_account).optional }
    it { should belong_to(:from_financial_account).with_foreign_key("from_financial_account_id").inverse_of("transfer_transactions_as_origin").optional.class_name("FinancialAccount") }
    it { should belong_to(:to_financial_account).with_foreign_key("to_financial_account_id").inverse_of("transfer_transactions_as_receiver").optional.class_name("FinancialAccount") }
  end

  context "common validations" do
    it { should validate_presence_of(:date) }
  end

  context "transfers validations" do
    it "should have a from_financial_account_id" do
      transaction = build :transfer_transaction, from_financial_account: nil
      expect(transaction.save).to be false
    end

    it "should have a to_financial_account_id" do
      transaction = build :transfer_transaction, to_financial_account: nil
      expect(transaction.save).to be false
    end

    it "should set category to nil after saving" do
      transaction = build :transfer_transaction
      transaction.category = create :category, account: transaction.account
      transaction.save
      expect(transaction.category).to be nil
    end
  end

  context "income validations" do
    it "should have a financial_account" do
      transaction = build :income_transaction, financial_account: nil
      expect(transaction.save).to be false
    end

    it "should have a category" do
      transaction = build :income_transaction, category: nil
      expect(transaction.save).to be false
    end

    it "should set from_financial_account to nil after saving" do
      transaction = build :income_transaction
      transaction.from_financial_account = create :financial_account, account: transaction.account
      transaction.save
      expect(transaction.from_financial_account).to be nil
    end

    it "should set to_financial_account to nil after saving" do
      transaction = build :income_transaction
      transaction.to_financial_account = create :financial_account, account: transaction.account
      transaction.save
      expect(transaction.to_financial_account).to be nil
    end
  end

  context "expense validations" do
    it "should have a financial_account" do
      transaction = build :expense_transaction, financial_account: nil
      expect(transaction.save).to be false
    end

    it "should have a category" do
      transaction = build :expense_transaction, category: nil
      expect(transaction.save).to be false
    end

    it "should set from_financial_account to nil after saving" do
      transaction = build :expense_transaction
      transaction.from_financial_account = create :financial_account, account: transaction.account
      transaction.save
      expect(transaction.from_financial_account).to be nil
    end

    it "should set to_financial_account to nil after saving" do
      transaction = build :expense_transaction
      transaction.to_financial_account = create :financial_account, account: transaction.account
      transaction.save
      expect(transaction.to_financial_account).to be nil
    end
  end
end
