module TransactionFilters
  extend ActiveSupport::Concern

  def filter_transactions(transactions)
    opts = params.permit(:from_date, :to_date, :description_contains)

    begin
      from_date = DateTime.parse(opts[:from_date]).midnight
      to_date = DateTime.parse(opts[:to_date]).end_of_day
    rescue Date::Error, TypeError
      from_date = ""
      to_date = ""
    end

    transactions.ransack(
      "date_gteq" => from_date,
      "date_lteq" => to_date,
      "description_i_cont" => opts[:description_contains]
    ).result(distinct: true)
  end
end
