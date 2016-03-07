# Preview all emails at http://localhost:3000/rails/mailers/reservation
class ReservationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/reservation/reservation_confirmation
  def reservation_confirmation
    Reservation.reservation_confirmation
  end

end
