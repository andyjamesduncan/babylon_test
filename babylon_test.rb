require_relative './babylon_prom.rb'

RSpec.describe Checkout do
  
  before :each do
    promotional_rules = {
      '001' => {'base_price' => 9.25,'bulk_discount' => {2 => 8.50, 3 => 8.0, 5 => 7.0}},
      '002' => {'base_price' => 45.0},
      '003' => {'base_price' => 19.95},
      'GEN' => {'total_discount' => {60.0 => 0.10, 100.0 => 0.15, 140.0 => 0.20}}
    }
    @co = Checkout.new(promotional_rules)
  end

  it "Checkout takes one rules parameter hash and returns a Checkout object" do
    expect(@co).to be_an_instance_of(Checkout)
  end

  it "Checking first Babylon-supplied client test, checks basic pricing works" do

    @co.scan('001')
    @co.scan('002')
    @co.scan('003')
    price = @co.total

    expect(price).to eql(66.78)
  end

  it "Checking second Babylon-supplied client test, checks that exact bulk purchase works as supplied in bulk rules" do

    @co.scan('001')
    @co.scan('003')
    @co.scan('001')
    price = @co.total

    expect(price).to eql(36.95)
  end

  it "Checking third Babylon-supplied client test, checks that bulk discount and total discount work" do

    @co.scan('001')
    @co.scan('002')
    @co.scan('001')
    @co.scan('003')
    price = @co.total

    expect(price).to eql(73.76)
  end

  it "Checking that discounting works when supplied with bulk volume which lies between two different bulk rules" do

    @co.scan('001')
    @co.scan('001')
    @co.scan('001')
    @co.scan('001')
    price = @co.total

    expect(price).to eql(32.0)
  end

  it "Checking that discounting works when supplied with bulk volume which lies above all bulk rules" do

    @co.scan('001')
    @co.scan('001')
    @co.scan('001')
    @co.scan('001')
    @co.scan('001')
    @co.scan('001')
    price = @co.total

    expect(price).to eql(42.0)
  end

  it "Checking that total discounting works without any bulk discounts being applied" do

    @co.scan('002')
    @co.scan('002')
    price = @co.total

    expect(price).to eql(81.0)
  end

  it "Checking that total discounting works when initial total above highest total discount option" do

    @co.scan('002')
    @co.scan('002')
    @co.scan('002')
    @co.scan('002')
    price = @co.total

    expect(price).to eql(144.0)
  end

  it "Checking edge case that program fails to fall over when not supplied with any items" do

    price = @co.total

    expect(price).to eql(0.0)
  end

end
