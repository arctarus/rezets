require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "New Recipe", %q{
  In order to not lost my recipes
  As a user
  I want to create a new recipe
} do

  background do
    @user = Factory :user
    login_as @user
  end

  scenario "with valid attributes" do
    recipe_name = Faker::Lorem.sentence(rand(10))
    category_name = _('carne')
    photo_path = image_path "recipe.jpg"
    ingredient_unit = "gramos"
    ingredient_name = Faker::Name.name

    click_link _("create a new recipe")
    fill_in "recipe_name", :with => recipe_name
    select category_name, :from => _("category")
    attach_file _("photo"), photo_path
    fill_in _("number of people"), :with => sample_number(10)
    
    within "#recipe_ingredients" do
      fill_in 'recipe_new_recipe_ingredients_attributes__value', :with => sample_number(10)
      fill_in 'recipe_new_recipe_ingredients_attributes__value_type', :with => ingredient_unit
      fill_in 'recipe_new_recipe_ingredients_attributes__name', :with => ingredient_name
    end

    fill_in _("preparation time"), :with => sample_number(60)
    fill_in _("directions"), :with => sample_paragraphs
    click_button _("create")

    should_be_on user_path(@user)
    save_and_open_page
    should_see recipe_name
    should_see category_name
  end
end
