class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_current_user

  private

  def get_current_user
    @user = current_user
  end
end
