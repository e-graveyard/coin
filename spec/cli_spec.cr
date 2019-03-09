require "./spec_helper.cr"

describe CLI::Parser do
  it "can show the help message" do
    perform_cmd?("-h").should be_true
  end

  it "can show the program version" do
    perform_cmd?("-v").should be_true
  end

  it "fails when no operand is passed" do
    perform_cmd?("").should be_false
  end

  it "fails when an unknown option is passed" do
    perform_cmd?("--unknown").should be_false
  end

  it "fails when zero is passed as amount" do
    perform_cmd?("0", "usd").should be_false
  end

  it "fails when no target currency is passed" do
    perform_cmd?("1", "usd").should be_false
  end

  it "fails when an invalid origin currency is passed" do
    perform_cmd?("0", "nope", "usd").should be_false
  end

  it "fails when an invalid target currency is passed" do
    perform_cmd?("0", "usd", "nope").should be_false
  end

  it "fails when a currency is converted to itself" do
    perform_cmd?("1", "usd", "usd").should be_false
  end

  it "fails when a non decimal number is passed" do
    perform_cmd?("1,0", "usd", "usd").should be_false
  end

  it "can parse an integer conversion" do
    perform_cmd?("1", "usd", "jpy").should be_true
  end

  it "can parse an integer conversion to multiple targets" do
    perform_cmd?("1", "usd", "jpy", "eur", "brl").should be_true
  end

  it "can parse a decimal conversion" do
    perform_cmd?("1.0", "usd", "jpy").should be_true
  end

  it "can parse an integer conversion to multiple targets" do
    perform_cmd?("1.0", "usd", "jpy", "eur", "brl").should be_true
  end
end
