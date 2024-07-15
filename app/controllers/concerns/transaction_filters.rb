module TransactionFilters
  extend ActiveSupport::Concern
  include DateFilterable
  include StringSearchable
  include Paginateable

  def filter_transactions(transactions)
    a = filter_by_date transactions
    a = search_from(:description, a)
    paginate a.result(distinct: true)
  end
end
