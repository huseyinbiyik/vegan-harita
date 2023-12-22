import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["map", "latitude", "longitude", "place_id", "field"];

  connect() {
    if (typeof google != "undefined") {
      this.initializeMap();
    }
  }

  initializeMap() {
    this.map();
    this.marker();
    this.autocomplete();
  }

  map() {
    if (this._map == undefined) {
      this._map = new google.maps.Map(this.mapTarget, {
        center: new google.maps.LatLng(
          this.latitudeTarget.value || 38.9597594,
          this.longitudeTarget.value || 34.9249653
        ),
        zoom: 4,
      });
    }
    return this._map;
  }

  marker() {
    if (this._marker == undefined) {
      this._marker = new google.maps.Marker({
        map: this.map(),
        anchorPoint: new google.maps.Point(0, 0),
      });
      let mapLocation = {
        lat: parseFloat(this.latitudeTarget.value),
        lng: parseFloat(this.longitudeTarget.value),
      };
      this._marker.setPosition(mapLocation);
      this._marker.setVisible(true);
    }
    return this._marker;
  }

  autocomplete() {
    if (this._autocomplete == undefined) {
      this._autocomplete = new google.maps.places.Autocomplete(
        this.fieldTarget
      );
      this._autocomplete.bindTo("bounds", this.map());
      this._autocomplete.setFields([
        "address_components",
        "geometry",
        "icon",
        "name",
        "place_id",
      ]);
      this._autocomplete.setComponentRestrictions({ country: ["tr"] });
      this._autocomplete.addListener(
        "place_changed",
        this.locationChanged.bind(this)
      );
    }
    return this._autocomplete;
  }

  locationChanged() {
    let place = this.autocomplete().getPlace();

    if (!place.geometry) {
      window.alert("No details available for input: '" + place.name + "'");
      return;
    }

    this.map().fitBounds(place.geometry.viewport);
    this.map().setCenter(place.geometry.location);
    this.marker().setPosition(place.geometry.location);
    this.marker().setVisible(true);

    this.latitudeTarget.value = place.geometry.location.lat();
    this.longitudeTarget.value = place.geometry.location.lng();
    this.place_idTarget.value = place.place_id;
  }

  preventSubmit(e) {
    if (e.key == "Enter") {
      e.preventDefault();
    }
  }

  disconnect() {
    if (this._autocomplete != undefined) {
      google.maps.event.clearInstanceListeners(this.fieldTarget);
    }
    this.map().unbindAll();
  }
}
