module CategoriesHelper
  
  def categories_options_for_select
    options_from_collection_for_select Category.order("name asc"), :id, :name
  end

end
