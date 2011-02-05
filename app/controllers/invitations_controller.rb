# coding: utf-8
class InvitationsController < ApplicationController
  respond_to :html
  before_filter :require_user, :only => [:new, :create]

  # GET /invitations
  # GET /invitations.xml
  def index
    if current_user.id == 1
      @invitations = Invitation.all.order('created_at desc').
        paginate(:page => params[:page], :per_page => 20)
      @page_title = "invitaciones enviadas"
    else
      render :layout => false, :file => '/public/404.html', :status => 404
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
    respond_to do |format|
      if @invitation.save
        UserMailer.invitation(@invitation, params["mail"], current_user).deliver
        flash[:notice] = "Invitación enviada correctamente a #{@invitation.email}"
        format.html { redirect_to current_user }
        format.xml { render :xml => @invitation, :status => :created, :location => @invitation }
      else
        flash[:notice] = "No se ha poditio enviar la invitación"
        format.html { render :action => "new" }
        format.xml { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

end
