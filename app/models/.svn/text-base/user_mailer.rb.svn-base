class UserMailer < ActionMailer::Base
 
 def feedback(feedback)
   recipients "rezets.com@gmail.com"
   from       feedback['email']
   reply_to   feedback["email"]
   subject    "feedback de #{feedback["name"]}"
   sent_on    Time.now
   body       :name => feedback["name"], :message => feedback["message"]
 end 

 def invitation(invitation, mail, user)
   recipients invitation.email
   from       user.name
   reply_to   "rezets.com@gmail.com"
   subject    mail["subject"]
   sent_on    Time.now
   body       :user => user, :invitation => invitation, :message => mail["message"]
 end

 def comment_recipe(comment, user)
   # el autor recibe el mail de un comentario de otro
   if user == comment.recipe.author
     _subject = "#{comment.user.name} ha comentado tu receta de #{comment.recipe.name}"
   # el que comenta la receta es el autor pero se envia a otro
   elsif comment.user == comment.recipe.author
     _subject = "#{comment.user.name} ha comentado su receta de #{comment.recipe.name}"
   # un usuario comenta la receta de otro y le llega a un 3º
   else
    _subject = "#{comment.user.name} ha comentado la receta de #{comment.recipe.name} de #{comment.recipe.author.name}"
  end

   recipients user.email
   from       "rezets.com@gmail.com"
   reply_to   "rezets.com@gmail.com"
   subject    _subject
   sent_on    Time.now
   body       :subject => _subject, :user => user, :comment => comment
 end

end
