require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecipesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "recipes", :action => "index").should == "/recipes"
    end
  
    it "maps #new" do
      route_for(:controller => "recipes", :action => "new").should == "/recipes/new"
    end
  
    it "maps #show" do
      route_for(:controller => "recipes", :action => "show", :id => "1").should == "/recipes/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "recipes", :action => "edit", :id => "1").should == "/recipes/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "recipes", :action => "create").should == {:path => "/recipes", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "recipes", :action => "update", :id => "1").should == {:path =>"/recipes/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "recipes", :action => "destroy", :id => "1").should == {:path =>"/recipes/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/recipes").should == {:controller => "recipes", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/recipes/new").should == {:controller => "recipes", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/recipes").should == {:controller => "recipes", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/recipes/1").should == {:controller => "recipes", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/recipes/1/edit").should == {:controller => "recipes", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/recipes/1").should == {:controller => "recipes", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/recipes/1").should == {:controller => "recipes", :action => "destroy", :id => "1"}
    end
  end
end
