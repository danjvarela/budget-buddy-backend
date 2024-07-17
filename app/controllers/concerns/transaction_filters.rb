module TransactionFilters
  extend ActiveSupport::Concern
  include DateFilterable
  include StringSearchable
  include Paginateable
  include Sortable

  def filter_transactions(transactions)
    opts = params.permit(:category_id, :financial_account_id)

    pre_filtered_transactions = opts[:category_id].present? ? transactions.where(category_id: opts[:category_id]) : transactions
    pre_filtered_transactions = opts[:financial_account_id].present? ? pre_filtered_transactions.where(financial_account_id: opts[:financial_account_id]) : pre_filtered_transactions

    a = filter_by_date pre_filtered_transactions
    a = search_from(:description, a)
    a = sort(a)
    paginate a
  end
end
