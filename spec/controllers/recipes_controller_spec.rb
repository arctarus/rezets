require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecipesController do

  def mock_recipe(stubs={})
    @mock_recipe ||= mock_model(Recipe, stubs)
  end

  def mock_category(stubs={})
    @mock_category ||= mock_model(Category, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all categories as @categories" do
      Recipe.should_receive(:random).and_return(mock_recipe)
      Category.should_receive(:all).and_return([mock_category])
      mock_category.should_receive(:recipes).and_return([mock_recipe])
      get :index
      assigns[:categories].should == [mock_category]
    end

    describe "with mime type of xml" do
  
      it "should render all recipes as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Recipe.should_receive(:find).with(:all).and_return(recipes = mock("Array of Recipes"))
        recipes.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

# describe "responding to GET show" do

#   it "should expose the requested recipe as @recipe" do
#     Recipe.should_receive(:find).with("37").and_return(mock_recipe)
#     get :show, :id => "37"
#     assigns[:recipe].should equal(mock_recipe)
#   end
#   
#   describe "with mime type of xml" do

#     it "should render the requested recipe as xml" do
#       request.env["HTTP_ACCEPT"] = "application/xml"
#       Recipe.should_receive(:find).with("37").and_return(mock_recipe)
#       mock_recipe.should_receive(:to_xml).and_return("generated XML")
#       get :show, :id => "37"
#       response.body.should == "generated XML"
#     end

#   end
#   
# end

# describe "responding to GET new" do
# 
#   it "should expose a new recipe as @recipe" do
#     Recipe.should_receive(:new).and_return(mock_recipe)
#     get :new
#     assigns[:recipe].should equal(mock_recipe)
#   end

# end

# describe "responding to GET edit" do
# 
#   it "should expose the requested recipe as @recipe" do
#     Recipe.should_receive(:find).with("37").and_return(mock_recipe)
#     get :edit, :id => "37"
#     assigns[:recipe].should equal(mock_recipe)
#   end

# end

# describe "responding to POST create" do

#   describe "with valid params" do
#     
#     it "should expose a newly created recipe as @recipe" do
#       Recipe.should_receive(:new).with({'these' => 'params'}).and_return(mock_recipe(:save => true))
#       post :create, :recipe => {:these => 'params'}
#       assigns(:recipe).should equal(mock_recipe)
#     end

#     it "should redirect to the created recipe" do
#       Recipe.stub!(:new).and_return(mock_recipe(:save => true))
#       post :create, :recipe => {}
#       response.should redirect_to(recipe_url(mock_recipe))
#     end
#     
#   end
#   
#   describe "with invalid params" do

#     it "should expose a newly created but unsaved recipe as @recipe" do
#       Recipe.stub!(:new).with({'these' => 'params'}).and_return(mock_recipe(:save => false))
#       post :create, :recipe => {:these => 'params'}
#       assigns(:recipe).should equal(mock_recipe)
#     end

#     it "should re-render the 'new' template" do
#       Recipe.stub!(:new).and_return(mock_recipe(:save => false))
#       post :create, :recipe => {}
#       response.should render_template('new')
#     end
#     
#   end
#   
# end

# describe "responding to PUT udpate" do

#   describe "with valid params" do

#     it "should update the requested recipe" do
#       Recipe.should_receive(:find).with("37").and_return(mock_recipe)
#       mock_recipe.should_receive(:update_attributes).with({'these' => 'params'})
#       put :update, :id => "37", :recipe => {:these => 'params'}
#     end

#     it "should expose the requested recipe as @recipe" do
#       Recipe.stub!(:find).and_return(mock_recipe(:update_attributes => true))
#       put :update, :id => "1"
#       assigns(:recipe).should equal(mock_recipe)
#     end

#     it "should redirect to the recipe" do
#       Recipe.stub!(:find).and_return(mock_recipe(:update_attributes => true))
#       put :update, :id => "1"
#       response.should redirect_to(recipe_url(mock_recipe))
#     end

#   end
#   
#   describe "with invalid params" do

#     it "should update the requested recipe" do
#       Recipe.should_receive(:find).with("37").and_return(mock_recipe)
#       mock_recipe.should_receive(:update_attributes).with({'these' => 'params'})
#       put :update, :id => "37", :recipe => {:these => 'params'}
#     end

#     it "should expose the recipe as @recipe" do
#       Recipe.stub!(:find).and_return(mock_recipe(:update_attributes => false))
#       put :update, :id => "1"
#       assigns(:recipe).should equal(mock_recipe)
#     end

#     it "should re-render the 'edit' template" do
#       Recipe.stub!(:find).and_return(mock_recipe(:update_attributes => false))
#       put :update, :id => "1"
#       response.should render_template('edit')
#     end

#   end

# end

# describe "responding to DELETE destroy" do

#   it "should destroy the requested recipe" do
#     Recipe.should_receive(:find).with("37").and_return(mock_recipe)
#     mock_recipe.should_receive(:destroy)
#     delete :destroy, :id => "37"
#   end
# 
#   it "should redirect to the recipes list" do
#     Recipe.stub!(:find).and_return(mock_recipe(:destroy => true))
#     delete :destroy, :id => "1"
#     response.should redirect_to(recipes_url)
#   end

# end

end
