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

end
