class HomeController < ApplicationController
  def contact; end

  def send_mail
    ContactMailer.contact_email(params[:name], params[:email], params[:message], params[:images]).deliver_now
    redirect_to contact_path, notice: 'Message received, thanks!'
  end
end
