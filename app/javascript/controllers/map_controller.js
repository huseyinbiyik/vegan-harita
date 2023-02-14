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
        disableDefaultUI: true,
        zoomControl: false,
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
      // locationButton.textContent = "Pan to Current Location";
      // add find-me image to locationButton from app/assets
      locationButton.innerHTML = `<img src="${window.location.origin}/assets/find-me.svg" alt="find-me">`;
      locationButton.classList.add("custom-map-control-button");
      // add id to locationButton
      locationButton.id = "location-button";
      map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(
        locationButton
      );
      locationButton.addEventListener("click", centerToMyCurrentLocation);
      centerToMyCurrentLocation();

      // Marker icons located on public folder
      const fullyVeganMarkerIcon = "fully-vegan-marker-icon.png";
      const veganFriendlyMarkerIcon = "has-vegan-options-marker-icon.png";

      console.log(locations);
      // Create markers for each location
      const markers = locations.map((position) => {
        let label = position.name;
        const marker = new google.maps.Marker({
          position,
          icon: {
            url: position.fully_vegan
              ? fullyVeganMarkerIcon
              : veganFriendlyMarkerIcon,
            scaledSize: new google.maps.Size(30, 40),
          },
        });

        // Info window on click
        marker.addListener("click", () => {
          infoWindow.setContent(
            // Link to the place page
            label
              ? `<a href=${
                  window.location.origin + "/places/" + position.id
                } class="info-window"><img src="#" alt=${label}_images[0]><h3>${label}</h3><p>${
                  position.address
                }</p></a>`
              : ""
          );
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
