module HelperMethods

  def login_as(user)
    visit login_path
    fill_in _('email'), :with => user.email
    fill_in _('password'), :with => user.password
    click_button _('come on in')
  end

  def should_be_on(page_path)
    current_path = URI.parse(current_url).path
    current_path.should == page_path
  end

  def should_see(text)
    page.should have_content(text)
  end

  def sample_number(num = 10)
    rand(num)+1
  end

  def sample_name
    Faker::Name.name
  end

  def sample_sentence(num = 10)
    Faker::Lorem.sentence(rand(num)+1)
  end

  def sample_paragraphs(num = 5)
    Faker::Lorem.paragraphs(rand(num)+1).join("\n\n")
  end

  def image_path(name)
    "#{Rails.root}/spec/acceptance/support/images/#{name}"
  end

  def fill_in_ingredient_with(args)
    within "#recipe_ingredients" do
      fill_in 'recipe_new_recipe_ingredients_attributes__value', :with => args[:value]
      fill_in 'recipe_new_recipe_ingredients_attributes__value_type', :with => args[:unit]
      fill_in 'recipe_new_recipe_ingredients_attributes__name', :with => args[:name]
    end
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance