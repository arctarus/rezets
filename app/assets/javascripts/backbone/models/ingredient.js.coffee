class Rezets.Models.Ingredient extends Backbone.Model
  paramRoot: 'ingredient'

  defaults:

class Rezets.Collections.IngredientsCollection extends Backbone.Collection
  model: Rezets.Models.Ingredient
  url: '/ingredients'
