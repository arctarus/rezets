(function($){

  window.Ingredient = Backbone.Model.extend({});

  window.Ingredients = Backbone.Collection.extend({
    model: Ingredient,
    url: '/ingredients'
  });

  window.Pantry = new Ingredients;

  window.IngredientView = Backbone.View.extend({
    tagName: 'li',
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

  window.PantryView = Backbone.View.extend({
    tagName: 'fieldset',
    id: 'ingredients',

    initialize: function(){
      _.bindAll(this, 'render');
      this.template = _.template($('#ingredient-list-template').html());
      this.collection.bind('reset', this.render);
    },

    render: function(){
      var $ingredients,
          collection = this.collection;

      $(this.el).css({border:'1px solid red'});
      $('#ingredients').html(this.template({}));
      $ingredients = $('#ingredients ul.ingredients-list');
      collection.each(function(ingredient){
        var view = new IngredientView({ model: ingredient });
        $ingredients.append(view.render().el);
      });
      return this;
    }
  });


  $(function(){
    var pantryView = new PantryView({collection:window.Pantry});
    window.Pantry.fetch();
  });

})(jQuery);
