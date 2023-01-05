import { Controller } from "@hotwired/stimulus";
import { MarkerClusterer } from "@googlemaps/markerclusterer";

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["map"];
  connect() {
    var script = document.createElement("script");
    script.src =
      "https://maps.googleapis.com/maps/api/js?key=AIzaSyCd7rrq1f7qe3Ph6nN3FtArXTaSMIkFUQY&callback=initMap";
    script.async = true;

    window.initMap = function () {
      // The map, centered at Kadikoy
      const map = new google.maps.Map(document.getElementById("map"), {
        zoom: 14,
        center: { lat: 40.990335, lng: 29.029163 },
      });

      const infoWindow = new google.maps.InfoWindow({
        content: "",
        disableAutoPan: true,
      });

      const centerToMyCurrentLocation = () => {
        // Try HTML5 geolocation.
        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(
            (position) => {
              const pos = {
                lat: position.coords.latitude,
                lng: position.coords.longitude,
              };

              infoWindow.setPosition(pos);
              infoWindow.setContent("Location found.");
              infoWindow.open(map);
              map.setCenter(pos);
            },
            () => {
              handleLocationError(true, infoWindow, map.getCenter());
            }
          );
        } else {
          // Browser doesn't support Geolocation
          handleLocationError(false, infoWindow, map.getCenter());
        }
      };

      function handleLocationError(browserHasGeolocation, infoWindow, pos) {
        infoWindow.setPosition(pos);
        infoWindow.setContent(
          browserHasGeolocation
            ? "Error: The Geolocation service failed."
            : "Error: Your browser doesn't support geolocation."
        );
        infoWindow.open(map);
      }

      const locationButton = document.createElement("button");
      locationButton.textContent = "Pan to Current Location";
      locationButton.classList.add("custom-map-control-button");
      map.controls[google.maps.ControlPosition.TOP_CENTER].push(locationButton);
      locationButton.addEventListener("click", centerToMyCurrentLocation);
      centerToMyCurrentLocation();

      const markerIcon = "/assets/marker.png";

      const markers = locations.map((position) => {
        let label = position.name;
        const marker = new google.maps.Marker({
          position,
          icon: markerIcon,
          label,
        });

        marker.addListener("click", () => {
          infoWindow.setContent(label);
          infoWindow.open(map, marker);
        });
        return marker;
      });

      new MarkerClusterer({ markers, map });
    };

    const locations = JSON.parse(this.mapTarget.dataset.mapPlaces);
    // Change locations keys to lat and lng
    locations.forEach((location) => {
      location.lat = location.latitude;
      location.lng = location.longitude;
    });

    // Append the 'script' element to 'head'
    document.head.appendChild(script);
  }
}
