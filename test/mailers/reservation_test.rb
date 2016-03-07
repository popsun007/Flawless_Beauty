require 'test_helper'

class ReservationTest < ActionMailer::TestCase
  test "reservation_confirmation" do
    mail = Reservation.reservation_confirmation
    assert_equal "Reservation confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
