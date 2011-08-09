class UpdatePasswordsController < ApplicationController
  load_and_authorize_resource :user, :find_by => :slug
  respond_to :html, :xml, :json

  def new
  end

  def create
    @user.update_attributes(params[:user])
    respond_with @user
  end

end
