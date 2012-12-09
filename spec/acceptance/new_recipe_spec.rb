require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "New Recipe", %q{
  In order to not lost my recipes
  As a user
  I want to create a new recipe
} do
  
  # Given
  background do
    Recipe.any_instance.stub(:save_attached_files).and_return(true)

    @user = sample :user
    @category = sample :category, :name => 'carne'
    login_as @user
  end

  scenario "with valid attributes" do
    recipe_name = sample_sentence
    category_name = _('carne')
    ingredient_unit = "gramos"
    ingredient_name = sample_name

    # When
    click_link _("create a new recipe")
    fill_in "recipe_name", :with => recipe_name
    select category_name, :from => _("Category")
    attach_file _("Select photo"), image_path("recipe.jpg")
    fill_in _("Number of people"), :with => sample_number
    
    fill_in_ingredient_with :value => sample_number, 
                            :unit => ingredient_unit, 
                            :name => ingredient_name

    fill_in _("Preparation time"), :with => sample_number(60)
    fill_in _("Directions"), :with => sample_paragraphs
    click_button _("Create")

    # Then
    should_be_on user_path(@user)
    should_see recipe_name
    should_see category_name
    should_see ingredient_name.downcase
  end
end
