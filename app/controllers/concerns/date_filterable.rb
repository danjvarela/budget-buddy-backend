module DateFilterable
  extend ActiveSupport::Concern

  def filter_by_date(transactions)
    opts = params.permit(:from_date, :to_date)

    begin
      from_date = DateTime.parse(opts[:from_date]).midnight
      to_date = DateTime.parse(opts[:to_date]).end_of_day
    rescue Date::Error, TypeError
      from_date = ""
      to_date = ""
    end

    transactions.ransack(
      "date_gteq" => from_date,
      "date_lteq" => to_date
    ).result(distinct: true)
  end
end
