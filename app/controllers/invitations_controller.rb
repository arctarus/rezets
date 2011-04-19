class InvitationsController < ApplicationController
  respond_to :html
  before_filter :require_user, :only => [:new, :create]

  # GET /invitations
  # GET /invitations.xml
  def index
    if current_user.id == 1
      @invitations = Invitation.order('created_at desc').
        paginate :page => params[:page]
    else
      page_not_found
    end
  end

  # GET /invitations/new
  # GET /invitations/new.xml
  def new
    @invitation = current_user.invitations_sent.new(params[:invitation])
    @remaining_invitations = 10 - Invitation.where(:sender_id => current_user.id).count
  end

  # POST /invitations
  # POST /invitations.xml
  def create
    @invitation = current_user.invitations_sent.new(params[:invitation])
    if @invitation.save
      UserMailer.invitation(@invitation, params["mail"], current_user).deliver
      flash[:notice] = _("Invitation send successfully to %{email}") % {:emal => @invitation.email}
    else
      flash[:notice] = _("Failed to send the invitation")
    end
  end

end
