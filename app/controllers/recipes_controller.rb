class RecipesController < ApplicationController

  def index
    #@chef =
    @recipes = Recipe.all
  end

end
