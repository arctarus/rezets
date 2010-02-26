require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/recipes/new.html.erb" do
  include RecipesHelper
  
  before(:each) do
    assigns[:recipe] = stub_model(Recipe,
      :new_record? => true,
      :name => "value for name",
      :directions => "value for directions",
      :cook_time => "1"
    )
  end

# it "should render new form" do
#   render "/recipes/new.html.erb"
#   
#   response.should have_tag("form[action=?][method=post]", recipes_path) do
#     with_tag("input#recipe_name[name=?]", "recipe[name]")
#     with_tag("textarea#recipe_directions[name=?]", "recipe[directions]")
#     with_tag("input#recipe_cook_time[name=?]", "recipe[cook_time]")
#   end
# end

end
