require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/recipes/show.html.erb" do
  include RecipesHelper
  
  before(:each) do
    assigns[:recipe] = @recipe = stub_model(Recipe,
      :name => "value for name",
      :directions => "value for directions",
      :cook_time => "1"
    )
  end

  it "should render attributes in <p>" do
    render "/recipes/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ directions/)
    response.should have_text(/1/)
  end
end

