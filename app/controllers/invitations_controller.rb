class InvitationsController < ApplicationController
  load_and_authorize_resource
  respond_to :html
  before_filter :require_user, :only => [:new, :create]

  def index
    @invitations = @invitations.order('created_at desc').
      paginate :page => params[:page]
  end

  def new
    @invitation = current_user.invitations_sent.new(params[:invitation])
    @remaining_invitations = 10 - Invitation.where(:sender_id => current_user.id).count
  end

  def create
    @invitation = current_user.invitations_sent.new(params[:invitation])
    if @invitation.save
      UserMailer.invitation(@invitation, params["mail"], current_user).deliver
      flash[:notice] = _("Invitation send successfully to %{email}") % {:email => @invitation.email}
    else
      flash[:notice] = _("Failed to send the invitation")
    end
    respond_with @invitation, :location => new_invitation_path
  end

end
