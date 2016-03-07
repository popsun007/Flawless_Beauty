class ReservationController < ApplicationController
  def index
    render :layout => false
  end

  def send_email
    render :text =>'reservation_confirmation.html.erb'
  end
end
