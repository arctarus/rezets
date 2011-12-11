class IngredientsController < ApplicationController
  respond_to :html, :json
  load_and_authorize_resource

  def index
    @ingredients = @ingredients.most_popular.limit(50)
    respond_with @ingredients
  end

end
