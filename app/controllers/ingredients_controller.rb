class IngredientsController < ApplicationController
  load_and_authorize_resource

  def index
    @ingredients = @ingredients.most_popular.limit(50)
  end

end
