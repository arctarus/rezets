module InvitationsHelper

  def email_message(user_name)
    _("Hi!\n\nI want to invite you to rezets.com.\n\nrezets.com is a new cooking recipe site where you can save all those recipes that you spread on pieces of paper, notebooks and folders and share them with your friends.\n\nI'm sure it will be very useful.\n\n%{user}") % {:user => user_name}
  end

end
