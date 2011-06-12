require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecipesHelper do
 
  describe "round" do
    it "0.5 return 1/2" do
      round(0.5).should == "&frac12;"
    end

    it "0.25 return 1/4" do
      round(0.25).should == "&frac14;"
    end

    it "0.3 return 1/3" do
      round(0.3).should == "&#8531;"
    end

    it "0.2 return 1/5" do
      round(0.2).should == "&#8533;"
    end

    it "2.0 return 2" do
      round(2.0).should == 2
    end

    it "2.5 return 2.5" do
      round(2.5).should == 2.5
    end
  end

end
