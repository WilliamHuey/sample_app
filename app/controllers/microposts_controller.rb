class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]

  def create

  end

  def destroy

  end
end