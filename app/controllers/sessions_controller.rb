class SessionsController < ApplicationController
  def create
    cwb_session = Session.create
    session[:token] = cwb_session[:token]

    render json: cwb_session
  end

  def destroy
    Session.destroy_for_token(params[:token] || session[:token])
    session[:token] = nil

    render nothing: true
  end

  def authenticated
    render json: {
      authenticated: !!session[:token],
      token: session[:token] || false
    }
  end
end
