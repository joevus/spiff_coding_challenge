require 'date'
require 'json'
require 'pry'

def calculate_commission(sales_rep_name, start_date, end_date)
  deal_data = deal_data(sales_rep_name)
  filtered_deals = filter_by_date(deal_data, start_date, end_date)

  sub_totals = filtered_deals.map do |deal|
    product = product_data(deal["product_id"])
    product_amount = product[product_amount]
    product_quantity = deal["quantity_products_sold"]
    commission_rate = product["commission_rate"]
    multiplier = determine_multiplier(deal["has_2x_multiplier"])

    sub_total = product_amount * product_quantity * commission_rate * multiplier
    sub_total
  end

  total_commission = sub_totals.sum

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

def product_data(product_id)
  file = File.read('data/products.json')
  data = JSON.parse(file)

  data = data.select { |product| product["id"] == product_id }
  data[0]
end
