require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/recipes/edit.html.erb" do
  include RecipesHelper
  
  before(:each) do
    assigns[:recipe] = @recipe = stub_model(Recipe,
      :new_record? => false,
      :name => "value for name",
      :directions => "value for directions",
      :cook_time => "1"
    )
  end

  it "should render edit form" do
    render "/recipes/edit.html.erb"
    
    response.should have_tag("form[action=#{recipe_path(@recipe)}][method=post]") do
      with_tag('input#recipe_name[name=?]', "recipe[name]")
      with_tag('textarea#recipe_directions[name=?]', "recipe[directions]")
      with_tag('input#recipe_cook_time[name=?]', "recipe[cook_time]")
    end
  end
end


