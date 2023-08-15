RSpec.describe 'calculate_commission' do
  let(:sales_rep_name) { "Carol"}
  let(:non_existent_name) { "King George V"}
  let(:start_date) { "2023-01-01"}
  let(:end_date) { "2023-03-31"}

  it 'should calculate commission' do
    # Calculation for Carol
    # Quantity * Price * Commission Rate
    # Deal 10027: 5 * 8000 * 0.1 = 4000
    # Deal 10037: 2 * 3000 * 0.08 = 480
    # Deal 10047: 1 * 1000 * 0.06 = 60 * 2 (has_2x_multiplier) = 120
    # Deal 10048 filtered out because it is outside of the date range
    # Total: 4600

    expect(calculate_commission(sales_rep_name, start_date, end_date)).to eq(4600)
  end

  describe 'deal_data' do
    it 'should retrieve deal data by sales rep name' do
      carol_deal_data = deal_data(sales_rep_name)

      expect(carol_deal_data.length).to eq(4)
      expect(carol_deal_data.first["id"]).to eq(10027)
    end
  end

  describe 'filter_by_date' do
    it 'should filter deal for date window' do
      carol_deal_data = deal_data(sales_rep_name)
      filtered_deal_data = filter_by_date(carol_deal_data, start_date, end_date)

      expect(filtered_deal_data.length).to eq(3)
    end
  end

  describe 'product_ids' do
    let(:deal_data) {
      [
        {
          "id": 1111,
          "sales_rep_name": "Melissa",
          "date": "2023-04-15",
          "quantity_products_sold": 7,
          "product_id": 20006,
          "has_2x_multiplier": 0
        },
        {
          "id": 1119,
          "sales_rep_name": "Melissa",
          "date": "2023-05-15",
          "quantity_products_sold": 11,
          "product_id": 20010,
          "has_2x_multiplier": 0
        }
      ]
    }

    it 'should retrieve product ids' do
      expect(product_ids(deal_data)).to eq([20006, 20010])
    end
  end
end