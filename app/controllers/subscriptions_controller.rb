# Newsletter Subscription Creation
class SubscriptionsController < ApplicationController
  respond_to :js
  skip_before_filter :verify_authenticity_token, :only => :create

  def new
    @subscription = Subscription.new
    respond_with @subscription
  end

  def create
    @subscription = Subscription.new params.for(Subscription).refine
    if @subscription.save
      redirect_to root_path, flash: { success: t('.success') }
    else
      render :new
    end
  end
end
