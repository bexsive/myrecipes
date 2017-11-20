require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @chef = Chef.create!(chefname: "Matthew", email: "Matthew.sykes@hotmail.com",
                    password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "Vegetable saute", description: "great vegetable sautee, add vegetable and oil", chef: @chef)
  end

  test "reject an invalid edit" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: {chefname: " ", email: "Matthew.sykes@hotmail.com" }}
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'

  end


  test "accept valid signup" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: {chefname: "Matt1", email: "Matthew1.sykes@hotmail.com" }}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Matt1", @chef.chefname
    assert_match "Matthew1.sykes@hotmail.com", @chef.email
  end
end
