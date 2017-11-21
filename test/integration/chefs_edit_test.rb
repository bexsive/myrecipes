require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @chef = Chef.create!(chefname: "Matthew", email: "Matthew.sykes@hotmail.com",
                    password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "john", email: "john@example.com",
                                    password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "Matthew1", email: "Matthew.sykes1@hotmail.com",
                    password: "password", password_confirmation: "password", admin: true)
  end

  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: {chefname: " ", email: "Matthew.sykes@hotmail.com" }}
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'

  end


  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: {chefname: "Matt1", email: "Matthew1.sykes@hotmail.com" }}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Matt1", @chef.chefname
    assert_match "matthew1.sykes@hotmail.com", @chef.email
  end

  test "Accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: {chefname: "Matt3", email: "Matthew3.sykes@hotmail.com" }}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Matt3", @chef.chefname
    assert_match "matthew3.sykes@hotmail.com", @chef.email
  end

  test "redirect edit attemped by another non-admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "joe"
    updated_email = "joe@example.com"
    patch chef_path(@chef), params: { chef: {chefname: updated_name, email: updated_email }}
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "Matthew", @chef.chefname
    assert_match "matthew.sykes@hotmail.com", @chef.email

  end
end
