require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecipeIngredient do
  let(:recipe_ingredient) { RecipeIngredient.new }

  describe "asign name" do
    it "create an ingredient when assings name" do
      recipe_ingredient.name = "new ingredient"
      recipe_ingredient.ingredient.name.should == "new ingredient"
    end

    it "return ingredient if exists" do
      ingredient = Ingredient.create(:name => 'cebolla')
      recipe_ingredient.name = "cebolla"
      recipe_ingredient.ingredient.name.should == "cebolla"
      ingredient.should eq(recipe_ingredient.ingredient)
    end
  end

  describe "destroy" do

    before :each do
      @ingredient = Ingredient.create :name => 'cebolla'
      recipe_ingredient.name = 'cebolla'
    end

    it "destroy ingredient if is not use" do
      recipe_ingredient.destroy
      Ingredient.find_by_name('cebolla').should be_nil
    end

    it "not destroy ingredient if is used for other recipe ingredient" do
      other_ri = RecipeIngredient.create(:name => 'cebolla')
      recipe_ingredient.destroy
      Ingredient.find_by_name('cebolla').should eq(@ingredient)
    end
  end

end
