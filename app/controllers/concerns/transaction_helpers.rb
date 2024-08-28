module TransactionHelpers
  extend ActiveSupport::Concern

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

  def include_pagination_data?
    params[:page].present? && params[:per_page].present?
  end

  def shared_params
    [:from_date, :to_date, :page, :per_page, :description_contains, :sort]
  end

  def apply_transaction_filters(transactions, opts = {})
    # resolve the :from_date and :to_date options
    begin
      from_date = DateTime.parse(opts[:from_date]).midnight
      to_date = DateTime.parse(opts[:to_date]).end_of_day
    rescue Date::Error, TypeError
      from_date = ""
      to_date = ""
    end

    # resolve the :sort options
    sort = opts[:sort] || ""
    sort_arr = sort.split(" ")
    # convert the attribute to snake_case
    sort_arr[0] = sort_arr[0].underscore if sort_arr[0].instance_of? String
    # convert `asc` or `desc` to uppercase
    sort_arr[1] = sort_arr[1].upcase if sort_arr[1].instance_of? String
    sort = sort_arr.join(" ")

    transactions.ransack(
      "date_gteq" => from_date,
      "date_lteq" => to_date,
      "description_i_cont" => opts[:description_contains]
    ).result(distinct: true).order(sort)
  end

  def render_transactions(transactions, serializer, opts = {})
    filtered_transactions = apply_transaction_filters transactions, opts.slice(:from_date, :to_date, :sort, :description_contains)
    optionally_paginated_transactions = include_pagination_data? ? filtered_transactions.paginate(opts.slice(:page, :per_page).to_h) : filtered_transactions
    serialized_data = ActiveModelSerializers::SerializableResource.new(optionally_paginated_transactions, each_serializer: serializer).serializable_hash

    if include_pagination_data?
      render json: {
        **pagination_data(optionally_paginated_transactions),
        **serialized_data
      }
    else
      render json: {totalCount: filtered_transactions.count, **serialized_data}
    end
  end
end
