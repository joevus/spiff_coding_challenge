require 'date'
require 'json'
require 'pry'

def calculate_commission(sales_rep_name, start_date, end_date)

  return total_commission
end

def deal_data(sales_rep_name)
  file = File.read('data/deals.json')
  data = JSON.parse(file)

  data_by_rep = data.select { |deal| deal["sales_rep_name"] == sales_rep_name }
  data_by_rep
end

def filter_by_date(deal_data, start_date, end_date)
  start_date = Date.parse(start_date)
  end_date = Date.parse(end_date)

  deal_data.select do |deal|
    date = Date.parse(deal[:date])
    date >= start_date && date <= end_date
  end
end