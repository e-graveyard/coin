require "./spec_helper.cr"

describe Currency do
  it "has 168 available currencies" do
    Currency::SYMBOLS.size.should eq 168
  end
end
