class PlaceOwner::QrCodeController < ApplicationController
  include PlaceOwner::PlaceOwnerVerification

  before_action :set_place

  def show
    @qr = RQRCode::QRCode.new("https://veganharita.com#{place_path(@place.slug)}#menu").as_svg(offset: 0, color: "01da5a", shape_rendering: "crispEdges", module_size: 6)
  end

  def download
    qr = RQRCode::QRCode.new("https://veganharita.com#{place_path(@place.slug)}#menu").as_svg(offset: 0, color: "01da5a", shape_rendering: "crispEdges", module_size: 6)
    send_data qr, type: "image/svg+xml", filename: "qr_code.svg", disposition: "attachment"
  end

  private

  def set_place
    @place = Place.find_by(slug: params[:slug])
  end
end
