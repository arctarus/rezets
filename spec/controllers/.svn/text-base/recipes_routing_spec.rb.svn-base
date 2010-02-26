require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecipesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "recipes", :action => "index").should == "/recipes"
    end
  
    it "should map #new" do
      route_for(:controller => "recipes", :action => "new").should == "/recipes/new"
    end
  
    it "should map #show" do
      route_for(:controller => "recipes", :action => "show", :id => "1").should == "/recipes/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "recipes", :action => "edit", :id => "1").should == "/recipes/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "recipes", :action => "update", :id => "1").should == "/recipes/update/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "recipes", :action => "destroy", :id => "1").should == "/recipes/destroy/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/recipes").should == {:controller => "recipes", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/recipes/new").should == {:controller => "recipes", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/recipes").should == {:controller => "recipes", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/recipes/1").should == {:controller => "recipes", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/recipes/1/edit").should == {:controller => "recipes", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/recipes/1").should == {:controller => "recipes", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/recipes/1").should == {:controller => "recipes", :action => "destroy", :id => "1"}
    end
  end
end
