# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :name => "Paco Pérez",
      :slug => "paco-perez",
      :email => "paco.perez@correo.es",
      :password => "xxxx",
      :password_confirmation => "xxxx"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
end
