module Sortable
  extend ActiveSupport::Concern

  def sort(ransack_query)
    opts = params.permit(:sort)
    sort = opts[:sort] || ""
    resolved_sort = sort.split(" ").map { |v| v.underscore }.join(" ")

    if resolved_sort.present?
      ransack_query.sorts = [resolved_sort]
    end

    ransack_query
  end
end
