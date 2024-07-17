module TransactionFilters
  extend ActiveSupport::Concern
  include DateFilterable
  include StringSearchable
  include Paginateable
  include Sortable

  def filter_transactions(transactions)
    opts = params.permit(:category_id)

    filtered_by_category = opts[:category_id].present? ? transactions.where(category_id: opts[:category_id]) : transactions

    a = filter_by_date filtered_by_category
    a = search_from(:description, a)
    a = sort(a)
    paginate a
  end
end
