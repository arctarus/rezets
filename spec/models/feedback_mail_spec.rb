require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedbackMail do
  let(:feedback_mail) { FeedbackMail.new }

  describe "attribute accessors" do
    it "has name as attribute" do
      feedback_mail.name = "User"
      feedback_mail.name.should == "User"
    end

    it "has email as attribute" do
      feedback_mail.email = "user@test.com"
      feedback_mail.email.should == "user@test.com"
    end
    
    it "has message as attribute" do
      feedback_mail.message = "hola que tal"
      feedback_mail.message.should == "hola que tal"
    end
  end

  describe "clean attributes" do
    it "clear name usign clear_name" do
      feedback_mail.name = "User"
      feedback_mail.clear_name
      feedback_mail.name.should be_nil
    end

    it "clear email usign clear_email" do
      feedback_mail.name = "user@test.com"
      feedback_mail.clear_email
      feedback_mail.email.should be_nil
    end
  end

  describe "ask if attribute is present" do
    it "name" do
      feedback_mail.name?.should be_false
      feedback_mail.name = "User"
      feedback_mail.name?.should be_true
    end

    it "email" do
      feedback_mail.email?.should be_false
      feedback_mail.email = "user@test.com"
      feedback_mail.email?.should be_true
    end
  end

  describe "compilance to active model" do
    require 'test/unit/assertions'
    require 'active_model/lint'
    include Test::Unit::Assertions
    include ActiveModel::Lint::Tests

    # to_s is to support ruby-1.9
    active_model_lint_tests = 
      ActiveModel::Lint::Tests.public_instance_methods.map(&:to_s).grep(/^test/)

    active_model_lint_tests.each do |m|
      example m.gsub('_',' ') do
        send m
      end
    end

    def model
      feedback_mail
    end

    it "expose singular name" do
      model.class.model_name.singular.should == "feedback_mail"
    end

    it "expose human name" do
      model.class.model_name.human.should == "Feedback mail"
    end

    it "use I18n" do
      begin
        I18n.backend.store_translations :es, 
        :activemodel => { :models => { :feedback_mail => 'My Feedback Mail' } }
        model.class.model_name.human.should == "My Feedback Mail"
      ensure
        I18n.reload!
      end
    end

    it "retrieve all attributes values" do
      feedback_mail.name = "User"
      feedback_mail.email = "user@test.com"
      feedback_mail.attributes["name"].should == "User"
      feedback_mail.attributes["email"].should == "user@test.com"
    end
  end

end
