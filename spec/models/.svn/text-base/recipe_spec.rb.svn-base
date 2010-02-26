require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Recipe do
  fixtures :categories, :users

  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :directions => "value for directions",
      :cook_time => "1",
      :category => categories(:one),
      :author => users(:one),
      :photo_file_name => "foto"
    }
    @recipe = Recipe.new
  end

  it "should create a new instance given valid attributes" do
    Recipe.create! @valid_attributes
  end
  
  it { @recipe.should have_many :recipe_ingredients }
  it { @recipe.should have_many :ingredients }
  it { @recipe.should validate_presence_of :name }
  it { @recipe.should validate_presence_of :directions }
  it { @recipe.should validate_length_of :name, :minimum => 5 }
  it { @recipe.should validate_presence_of :photo_file_name }
  it { @recipe.should validate_uniqueness_of :photo_file_name }

end
