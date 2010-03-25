require 'test_helper'

class FiremenControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
    end
    
    context "requesting GET :index" do
      setup do
        get :index
      end

      should_respond_with(:success)
      should_render_template("index")
      should_render_with_layout("back")
      
      should_assign_to(:firemen)
    end
    
    context "requesting GET :show for a non existing fireman" do
      setup do
        get :show, :id => 2458437589
      end
      
      should_respond_with(:redirect)
      should_redirect_to(":index") { firemen_path }

      should_set_the_flash(:error)
    end
        
    context "requesting GET :new" do
      setup do
        get :new
      end
    
      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
    end
    
    context "requesting POST :create with bad data" do
      setup do
        post :create, :fireman => {:firstname => '', :lastname => ''}
      end
    
      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
      
      should_not_change("number of firemen") { Fireman.count }
    end   
    
    context "requesting POST :create with good data" do
      setup do
        post :create, :fireman => Fireman.plan
      end
    
      should_respond_with(:redirect)
      should_redirect_to("fireman") { fireman_path(assigns(:fireman)) }
      
      should_assign_to(:fireman)
      should_change("number of firemen", :by => 1) { Fireman.count }
      should_set_the_flash(:success)
    end
    
    context "with an existing fireman" do
      setup do
        @fireman = make_fireman_with_grades(:station => @station)
      end
  
      context "requesting GET :show on existing fireman" do
        setup do
          get :show, :id => @fireman.id
        end
  
        should_respond_with(:success)
        should_render_template("show")
        should_render_with_layout("back")
      end
      
      context "requesting GET :edit" do
        setup do
          get :edit, :id => @fireman.id
        end
  
        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end  
      
      context "requesting PUT :update with bad data" do
        setup do
          put :update, :id => @fireman.id, :fireman => {:firstname => '', :lastname => ''}
        end
  
        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end  
      
      context "requesting PUT :update with good data" do
        setup do
          put :update, :id => @fireman.id, :fireman => Fireman.plan
        end
  
        should_respond_with(:redirect)
        should_redirect_to("fireman") { fireman_path(assigns(:fireman)) }

        should_set_the_flash(:success)
      end       
      
      context "requesting DELETE :destroy without associations" do
        setup do
          delete :destroy, :id => @fireman.id
        end
        
        should_redirect_to("firemen list") { firemen_path }
        
        should_change("number of firemen", :by => -1) { Fireman.count }
        should_set_the_flash(:success)
      end
      
      context "requesting DELETE :destroy with associations" do
        setup do
          Fireman.any_instance.stubs(:destroy).returns(false)
          # because there is no stub_chain for any_instance in mocha
          Fireman.any_instance.stubs(:errors).returns(mock(:full_messages => ["erreur"]))
          delete :destroy, :id => @fireman.id
        end
        
        should_redirect_to("fireman") { fireman_path(assigns(:fireman)) }
        
        should_not_change("number of firemen") { Fireman.count }
        should_set_the_flash(:error)
      end      
    end
  end
end
