class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :authenticate_user!
  include Pundit
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  private
  def permission_denied
    flash[:no_access] = "You have no access to the #{params[:controller]}/#{params[:action]} page."
    redirect_to root_path
  end
end
