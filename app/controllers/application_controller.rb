class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def index

  end

  def services
  end

  def about_us
  end

  def contact
  end

  def search
  end

  def reservation
  end

  def success
    Reservation.reservation_confirmation(params).deliver
    Reservation.reservation_confirmation_to_customer(params).deliver
  end
end
