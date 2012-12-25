module CategoriesHelper
  
  def categories_options_for_select(selected)
    options_from_collection_for_select Category.order("name asc"), :id, :name, selected
  end

end
