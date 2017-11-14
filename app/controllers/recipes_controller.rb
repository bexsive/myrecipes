class RecipesController < ApplicationController

  def index
    #@chef =
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

end
