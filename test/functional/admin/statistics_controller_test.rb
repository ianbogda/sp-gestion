require 'test_helper'

# ControllerTest generated by Typus, use it to test the extended admin functionality.
class Admin::StatisticsControllerTest < ActionController::TestCase

  fixtures(:typus_users)

  context "an user logged in" do
    setup do    
      @request.session[:typus_user_id] = typus_users(:admin).id
    end
    
    context "requesting GET :index" do
      setup do
        get :index
      end
      
      should_respond_with(:success)
      should_render_template("index")
      
      should_assign_to(:nb_nl_invited)
      should_assign_to(:nb_bc_used)
    end
  end
end