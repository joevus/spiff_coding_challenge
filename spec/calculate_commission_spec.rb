require_relative "../calculate_commission.rb"

RSpec.describe 'calculate_commission' do
  let(:sales_rep_name) { "Carol"}
  let(:non_existent_name) { "King George V"}
  let(:start_date) { "2023-01-01"}
  let(:end_date) { "2023-03-31"}

  let(:example_deal_data) {
    [
      {
        "id" => 1111,
        "sales_rep_name" => "Melissa",
        "date" => "2023-01-15",
        "quantity_products_sold" => 7,
        "product_id" => 20006,
        "has_2x_multiplier" => 0
      },
      {
        "id" => 1119,
        "sales_rep_name" => "Melissa",
        "date" => "2023-05-15",
        "quantity_products_sold" => 11,
        "product_id" => 20010,
        "has_2x_multiplier" => 0
      }
    ]
  }

  it 'should calculate commission' do
    # Calculation for Carol
    # Quantity * Product Amount * Commission Rate * 2x Multiplier
    # Deal 10027: 5 * 8000 * 0.1 = 4000
    # Deal 10037: 2 * 3000 * 0.08 = 480
    # Deal 10047: 1 * 1000 * 0.06 = 60 * 2 (has_2x_multiplier) = 120
    # Deal 10048 filtered out because it is outside of the date range
    # Total: 4600

    expect(calculate_commission(sales_rep_name, start_date, end_date)).to eq(4600)
  end

  
  it 'should return warning message if sales rep does not exist' do
    expect(calculate_commission(non_existent_name, start_date, end_date)).to eq("Sales rep does not exist")
  end
  
  context 'David test case' do
    let(:sales_rep_name) { "David"}
    let(:start_date) { "2023-04-01"}
    let(:end_date) { "2023-06-30"}

    it "should calculate commission for David" do
      expect(calculate_commission(sales_rep_name, start_date, end_date)).to eq(90090)
    end
  end
  
  
  describe 'deal_data' do
    it 'should retrieve deal data by sales rep name' do
      # This queries from data/deals.json
      carol_deal_data = deal_data(sales_rep_name)

      expect(carol_deal_data.length).to eq(4)
      expect(carol_deal_data.first["id"]).to eq(10027)
    end
  end

  describe 'determine_multiplier' do
    it 'should return 2 if given 1' do
      expect(determine_multiplier(1)).to eq(2)
    end

    it 'should return 1 if given 0' do
      expect(determine_multiplier(0)).to eq(1)
    end
  end

  describe 'filter_by_date' do
    it 'should filter deal for date window' do
      filtered_deal_data = filter_by_date(example_deal_data, start_date, end_date)

      expect(filtered_deal_data.length).to eq(1)
    end
  end

  describe 'product_data' do
    let(:expected_product_data) {
      {
        "id" => 20001,
        "name" => "Product_1",
        "product_amount" => 1000,
        "commission_rate" => 0.05
      }
    }

    it 'should retrieve product data by product id' do
      # queries from data/products.json
      expect(product_data(20001)).to eq(expected_product_data)
    end
  end

  describe 'subtotal' do
    let(:example_deal_data) {
      {
        "id" => 10001,
        "sales_rep_name" => "David",
        "date" => "2023-04-15",
        "quantity_products_sold" => 3,
        "product_id" => 20007,
        "has_2x_multiplier" => 0
      }
    }
    it 'should calculate subtotal' do
      # Deal 10001: 3 * 13000 * 0.11 * 1 = 4290

      expect(subtotal(example_deal_data)).to eq(4290)
    end
  end
end