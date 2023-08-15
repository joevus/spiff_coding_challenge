require 'date'
require 'json'
require 'pry'

# take arguments from command line
sales_rep_name = ARGV[0]
start_date = ARGV[1]
end_date = ARGV[2]

def calculate_commission(sales_rep_name, start_date, end_date)
  deal_data = deal_data(sales_rep_name)
  return error_message if deal_data.empty?

  filtered_deals = filter_by_date(deal_data, start_date, end_date)

  sub_totals = filtered_deals.map do |deal|
    subtotal(deal)
  end

  total_commission = sub_totals.sum.round

  return total_commission
end

def deal_data(sales_rep_name)
  file = File.read('data/deals.json')
  data = JSON.parse(file)

  data_by_rep = data.select { |deal| deal["sales_rep_name"] == sales_rep_name }
  data_by_rep
end

def determine_multiplier(num)
  if num == 1
    return 2
  else
    return 1
  end
end

def error_message
  "Sales rep does not exist"
end

def filter_by_date(deal_data, start_date, end_date)
  start_date = Date.parse(start_date)
  end_date = Date.parse(end_date)

  deal_data.select do |deal|
    date = Date.parse(deal["date"])
    date >= start_date && date <= end_date
  end
end

def product_data(product_id)
  file = File.read('data/products.json')
  data = JSON.parse(file)

  data = data.select { |product| product["id"] == product_id }
  data[0]
end

def subtotal(deal)
  product = product_data(deal["product_id"])
  product_amount = product["product_amount"]
  product_quantity = deal["quantity_products_sold"]
  commission_rate = product["commission_rate"]
  multiplier = determine_multiplier(deal["has_2x_multiplier"])

  sub_total = product_amount * product_quantity * commission_rate * multiplier
  sub_total
end

# Output commission
puts (calculate_commission(sales_rep_name, start_date, end_date))
