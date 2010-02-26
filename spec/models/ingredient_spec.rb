require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Ingredient do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
    }
    @ingredient = Ingredient.new
  end

  it "should create a new instance given valid attributes" do
    Ingredient.create!(@valid_attributes)
  end

  it "should update a instace given valid attributes" do
     @ingredient.name = @valid_attributes["name"]
     @ingredient.save
  end
end
