class UserMailer < ActionMailer::Base
  helper :recipes
 
  def feedback(feedback)
    @name     = feedback["name"]
    @message  = feedback["message"]
    mail  :to       => 'rezets.com@gmail.com',
          :from     => feedback['email'],
          :reply_to => feedback["email"],
          :subject  => _("feedback from #{feedback["name"]}"),
          :sent_on  => Time.now
  end 

  def invitation(invitation, tmpl, user)
    @user       = user
    @invitation = invitation
    @message    = mail["message"]
    mail  :to       => invitation.email,
          :subject  => tmpl['subject']

  #recipients invitation.email
  #from       user.name
  #reply_to   "rezets.com@gmail.com"
  #sent_on    Time.now
  end

  def comment_recipe(comment, user)
   # el autor recibe el mail de un comentario de otro
   if user == comment.recipe.author
     _subject = _("%{user} has commented on your %{recipe} recipe") % {:user => comment.user.name, :recipe => comment.recipe.name.downcase}
   # el que comenta la receta es el autor pero se envia a otro
   elsif comment.user == comment.recipe.author
     _subject = _("%{user} has commented on his %{recipe} recipe") % {:user => comment.user.name, :recipe => comment.recipe.name.downcase}
   # un usuario comenta la receta de otro y le llega a un 3º
   else
    _subject = _("%{user} has commented on %{author}'s %{recipe} recipe") % {:user => comment.user.name, :recipe => comment.recipe.name.downcase, :author => comment.recipe.author.name}
  end

   recipients user.email
   from       "rezets.com@gmail.com"
   reply_to   "rezets.com@gmail.com"
   subject    _subject
   sent_on    Time.now
   body       :subject => _subject, :user => user, :comment => comment
  end

  def recipe(recipe, email, current_user)
   user_name = email[:name].blank? ? current_user.name : email[:name]
   recipients email['recipients'].split(';')
   from       "rezets.com@gmail.com"
   reply_to   "rezets.com@gmail.com"
   subject    _("%{user} has sent you a %{recipe} recipe") % {:user => user_name, :recipe => recipe.name.downcase}
   sent_on    Time.now
   body       :recipe => recipe, :user_name => current_user.nil? ? user_name : current_user.name, :message => email['message']
  end

end
