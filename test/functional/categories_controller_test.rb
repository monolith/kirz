require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Category.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Category.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to categories_url
  end
  
  def test_edit
    get :edit, :id => Category.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Category.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Category.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Category.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Category.first
    assert_redirected_to categories_url
  end
end
