(function($){

  window.Ingredient = Backbone.Model.extend({});

  window.Ingredients = Backbone.Collection.extend({
    model: Ingredient,
    url: '/ingredients'
  });

  window.Pantry = new Ingredients;

  window.IngredientView = Backbone.View.extend({
    tag: 'li',
    className: 'ingredient',

    initialize: function(){
      _.bindAll(this, 'render');
      this.model.bind('change', this.render);
      this.template = _.template($('#ingredient-template').html());
    },

    render: function(){
      var renderedContent = this.template(this.model.toJSON());
      $(this.el).html(renderedContent);
      return this;
    }
  });

  window.IngredientsListView = Backbone.View.extend({
    tag: 'ul',
    className: 'ingredients',

    initialize: function(){
      _.bindAll(this, 'render');
      this.template = _.template($('#ingredient-list-template').html());
      this.collection.bind('reset', this.render);
    },

    render: function(){
      var $ingredients,
          collection = this.collection;

      $(this.el).html(this.template({}));
      $ingredients = $('.ingredients-list');
      collection.each(function(ingredient){
        var view = new IngredientView({
          model:ingredient
        });
        $ingredients.append(view.render().el);
      });
      return this;
    }
  });

  $(function(){
    window.Pantry.fetch();
    ingredientListView = new IngredientsListView({collection:Pantry.models});
    ingredientListView.render().el;
  });

})(jQuery);
