class HomeController < ApplicationController
  
  def index
    @categories = policy_scope(Category).includes(:tasks)
  end
end
