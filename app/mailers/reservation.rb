class Reservation < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reservation.reservation_confirmation.subject
  #
  def reservation_confirmation(infos)
    # @greeting = "Thank you for giving us an opportunity to be your beautician. We will contact to you shortly to confirm your reservation possibility"
    @infos = infos
    mail to: "hello@flawlessbeautysalon.us", subject: "Appointment Request"
  end

  def reservation_confirmation_to_customer(infos)
    # @greeting = "Thank you for giving us an opportunity to be your beautician. We will contact to you shortly to confirm your reservation possibility"
    @infos = infos
    mail to: infos["reservation-email"], subject: "Reservation Confirmation"
  end

  def reservation_message(infos)
    @infos = infos
    mail to: "hello@flawlessbeautysalon.us", subject: "Message from Customer"
  end
end
