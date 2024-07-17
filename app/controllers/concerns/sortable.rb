module Sortable
  extend ActiveSupport::Concern

  def sort(relation)
    opts = params.permit(:sort)
    sort = opts[:sort] || ""

    sort_arr = sort.split(" ")
    # convert the attribute to snake_case
    sort_arr[0] = sort_arr[0].underscore if sort_arr[0].instance_of? String
    # convert `asc` or `desc` to uppercase
    sort_arr[1] = sort_arr[1].upcase if sort_arr[1].instance_of? String

    resolved_sort = sort_arr.join(" ")

    relation.order resolved_sort
  end
end
