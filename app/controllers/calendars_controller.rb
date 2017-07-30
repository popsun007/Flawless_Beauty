class CalendarsController < ApplicationController
  skip_before_filter  :verify_authenticity_token #Allow making POST request to Google API

  def index
    client = Signet::OAuth2::Client.new({
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token'
    })

    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    # @event_list = service.list_calendar_lists
    @event_list = service.list_events("flawlessbeautyfremont@gmail.com")
    # render :layout => true
  end

  # def redirect
  #   client = Signet::OAuth2::Client.new({
  #     client_id: Rails.application.secrets.google_client_id,
  #     client_secret: Rails.application.secrets.google_client_secret,
  #     authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
  #     scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
  #     redirect_uri: callback_url
  #   })

  #   redirect_to client.authorization_uri.to_s
  # end

  # def callback
  #   client = Signet::OAuth2::Client.new({
  #     client_id: Rails.application.secrets.google_client_id,
  #     client_secret: Rails.application.secrets.google_client_secret,
  #     token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
  #     redirect_uri: callback_url,
  #     code: params[:code]
  #   })

  #   response = client.fetch_access_token!

  #   session[:authorization] = response

  #   redirect_to calendars_url
  # end


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

    start_time = Date.strptime(appointment_params["reservation-date"], '%m/%d/%Y').strftime('%Y-%m-%d')
    start_time = Date.parse start_time

    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date: start_time),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: start_time + appointment_params["reservation-duration"].to_f),
      summary: 'Event created from rails!'
    })

    begin 
      service.insert_event("flawlessbeautyfremont@gmail.com", event)
    rescue Google::Apis::AuthorizationError => exception
      client.authorization.grant_type = 'refresh_token'
      response = client.refresh!

      session[:authorization] = session[:authorization].merge(response)

      retry
    end

    redirect_to "/calendars"
  end


private

  def appointment_params
    params.permit("reservation-services", "reservation-name", "reservation-email", "reservation-phone", "reservation-date", "reservation-time", "reservation-duration", "reservation-note", "reservation-form", "reservation-services")
  end
end
