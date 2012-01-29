class UserMailer < ActionMailer::Base
  helper :recipes
  default :from => 'rezets.com@gmail.com',
          :reply_to => 'rezets.com@gmail.com'
 
  def invitation(invitation, tmpl, user)
    @user       = user
    @invitation = invitation
    @message    = mail["message"]
    mail :to => invitation.email, :subject => tmpl['subject']
  end

  def comment_recipe(comment, user)
    @user = user
    @comment = comment
    # el autor recibe el mail de un comentario de otro
    if @user == @comment.recipe.author
      @title = _("%{user} has commented on your %{recipe} recipe") % {:user => @comment.user.name, :recipe => @comment.recipe.name.downcase}
      # el que comenta la receta es el autor pero se envia a otro
    elsif @comment.user == @comment.recipe.author
      @title = _("%{user} has commented on his %{recipe} recipe") % {:user => @comment.user.name, :recipe => @comment.recipe.name.downcase}
      # un usuario comenta la receta de otro y le llega a un 3º
    else
      @title = _("%{user} has commented on %{author}'s %{recipe} recipe") % {:user => @comment.user.name,
        :recipe => @comment.recipe.name.downcase, :author => comment.recipe.author.name}
    end
    mail :to => @user.email, :subject => @title
  end

  def recipe(email)
    @recipe = email.recipe
    @user_name = email.name
    @message = email.message
    mail :to => email.recipients,
         :subject => _("%{user} has sent you a %{recipe} recipe") % {
          :user => email.name,
          :recipe => email.recipe.name.downcase}
  end

end
