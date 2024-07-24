module Paginateable
  extend ActiveSupport::Concern

  def paginate(relation)
    opts = params.permit(:page, :per_page)

    relation.paginate(
      page: opts[:page] || 1,
      per_page: opts[:per_page]
    )
  end

  def pagination_data(collection)
    {
      currentPage: collection.current_page,
      nextPage: collection.next_page,
      prevPage: collection.previous_page,
      totalPages: collection.total_pages,
      totalCount: collection.total_entries,
      perPageCount: collection.per_page
    }
  end
end
