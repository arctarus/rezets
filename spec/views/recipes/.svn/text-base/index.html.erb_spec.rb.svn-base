require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/recipes/index.html.erb" do
  include RecipesHelper
  
  before(:each) do
    assigns[:recipes] = [
      stub_model(Recipe,
        :name => "value for name",
        :directions => "value for directions",
        :cook_time => "1"
      ),
      stub_model(Recipe,
        :name => "value for name",
        :directions => "value for directions",
        :cook_time => "1"
      )
    ]
  end

  it "should render list of recipes" do
    render "/recipes/index.html.erb"
    response.should have_tag("div>h2", "value for name", 2)
    response.should have_tag("div>div", "value for directions", 2)
    response.should have_tag("div>p", "1", 2)
  end
end

