class CalendarsController < ApplicationController
  before_action :authenticate_user!
  skip_before_filter  :verify_authenticity_token #Allow making POST request to Google API

  def index
    render :layout => true
  end

  def callback
    client = Signet::OAuth2::Client.new({
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: callback_url,
      code: params[:code]
    })

    response = client.fetch_access_token!

    session[:authorization] = response

    redirect_to "/"
  end

  def booking
    Reservation.reservation_confirmation(params).deliver
    Reservation.reservation_confirmation_to_customer(params).deliver

    client = Signet::OAuth2::Client.new({
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token'
    })

    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    #Parse the date and time 
    date = Date.strptime(appointment_params["reservation-date"], '%m/%d/%Y').strftime('%Y-%m-%d')
    date = Date.parse(date)
    start_time = Time.parse(appointment_params["reservation-time"])
    duration_arr = appointment_params["reservation-duration"].split(".")
    end_time = start_time + duration_arr.first.to_i.hours + duration_arr.last.to_i.minutes

    start_time = DateTime.new(date.year, date.month, date.day, start_time.hour, start_time.min, start_time.sec, start_time.zone)
    end_time = DateTime.new(date.year, date.month, date.day, end_time.hour, end_time.min, end_time.sec, end_time.zone)

    start_time = start_time.to_datetime.rfc3339
    end_time = end_time.to_datetime.rfc3339

    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: start_time),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: end_time),
      summary: appointment_params["reservation-name"] + " " + appointment_params["reservation-phone"],
      description: "Email: " + appointment_params["reservation-email"] + "\n" + appointment_params["reservation-note"]
    })

    if session[:authorization].nil?
      client = Signet::OAuth2::Client.new({
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret,
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
        redirect_uri: callback_url
      })
      redirect_to client.authorization_uri.to_s
    else
      begin 
        service.insert_event("flawlessbeautyfremont@gmail.com", event)
        create_appointment(params, start_time)
      rescue Google::Apis::AuthorizationError => exception
          response = client.refresh!
        
          session[:authorization] = session[:authorization].merge(response)
        retry
      end
      redirect_to "/calendars"
    end
  end

  def create_appointment(params, appt_time)
    user = User.find_by(phone: params["reservation-phone"])
    if params["reservation-services"].present?
      service = params["reservation-services"].join(", ")
    end

    Appointment.create(
                        time:     appt_time,
                        duration: params["reservation-duration"],
                        service:  service,
                        note:     params["reservation-note"],
                        user_id:  user.id
                      )
  end

private

  def appointment_params
    params.permit("reservation-services", 
                  "reservation-name", 
                  "reservation-email", 
                  "reservation-phone", 
                  "reservation-date", 
                  "reservation-time", 
                  "reservation-duration", 
                  "reservation-note",
                  )
  end
end
