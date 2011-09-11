require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedbackForm do
  let(:feedback_form) { FeedbackForm.new }

  describe "attribute accessors" do
    it "has name as attribute" do
      feedback_form.name = "User"
      feedback_form.name.should == "User"
    end

    it "has email as attribute" do
      feedback_form.email = "user@test.com"
      feedback_form.email.should == "user@test.com"
    end
    
    it "has message as attribute" do
      feedback_form.message = "hola que tal"
      feedback_form.message.should == "hola que tal"
    end
  end

  describe "clean attributes" do
    it "clear name usign clear_name" do
      feedback_form.name = "User"
      feedback_form.clear_name
      feedback_form.name.should be_nil
    end

    it "clear email usign clear_email" do
      feedback_form.name = "user@test.com"
      feedback_form.clear_email
      feedback_form.email.should be_nil
    end
  end

  describe "ask if attribute is present" do
    it "name" do
      feedback_form.name?.should be_false
      feedback_form.name = "User"
      feedback_form.name?.should be_true
    end

    it "email" do
      feedback_form.email?.should be_false
      feedback_form.email = "user@test.com"
      feedback_form.email?.should be_true
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
      example m.gsub('_',' ').gsub('test ','') do
        send m
      end
    end

    def model
      feedback_form
    end

    it "expose singular name" do
      model.class.model_name.singular.should == "feedback_form"
    end

    it "expose human name" do
      model.class.model_name.human.should == "Feedback form"
    end

    it "use I18n" do
      begin
        I18n.backend.store_translations :es, 
        :activemodel => { :models => { :feedback_form => 'My Feedback Form' } }
        model.class.model_name.human.should == "My Feedback Form"
      ensure
        I18n.reload!
      end
    end

    it "retrieve all attributes values" do
      feedback_form.name = "User"
      feedback_form.email = "user@test.com"
      feedback_form.attributes["name"].should == "User"
      feedback_form.attributes["email"].should == "user@test.com"
    end
  end

  describe "delivers an email" do
    before :each do
      ActionMailer::Base.deliveries.clear
      feedback_form.email = Faker::Internet.email
      feedback_form.name = Faker::Name.name
      feedback_form.message = Faker::Lorem.paragraphs
      feedback_form.deliver
      @mail = ActionMailer::Base.deliveries.last
    end

    it "usign action mailer" do
      ActionMailer::Base.deliveries.should have(1).item
    end

    it "with from attribute get from feedback email" do
      @mail.from.should == [feedback_form.email]
    end

    it "with feedback mail in the body" do
      @mail.body.encoded.should include(feedback_form.email)
    end
  end
end
