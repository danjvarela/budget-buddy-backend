module TransactionFilters
  extend ActiveSupport::Concern
  include DateFilterable
  include StringSearchable
  include Paginateable
  include Sortable

  def filter_transactions(transactions)
    a = filter_by_date transactions
    a = search_from(:description, a)
    a = sort(a)
    paginate a.result(distinct: true)
  end
end
