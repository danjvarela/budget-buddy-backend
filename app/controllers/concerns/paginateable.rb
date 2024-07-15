module Paginateable
  extend ActiveSupport::Concern

  def paginate(relation)
    opts = params.permit(:page, :per_page)

    relation.paginate(
      page: opts[:page] || 1,
      per_page: opts[:per_page] || 20
    )
  end
end
