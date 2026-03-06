class HomeController < ApplicationController
  
  def index
    @categories = policy_scope(Category).includes(:user, tasks: :user)
  end
end
