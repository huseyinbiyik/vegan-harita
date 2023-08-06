import { Controller } from "@hotwired/stimulus";
import { MarkerClusterer } from "@googlemaps/markerclusterer";

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["map"];
  connect() {
    if (typeof google != "undefined") {
      this.fetchPlaces();
    }
  }

  fetchPlaces() {
    fetch("/places.json")
      .then((response) => response.json())
      .then((data) => {
        this.locations = data;
        this.initializeMap(this.locations);
      });
  }

  initializeMap(locations) {
    // The map, centered at Kadikoy
    const map = new google.maps.Map(this.mapTarget, {
      zoom: 14,
      center: { lat: 40.990335, lng: 29.029163 },
      disableDefaultUI: true,
      zoomControl: false,
      keyboardShortcuts: false,
    });

    // Custom zoom controls
    function CustomZoomInControl(controlDiv, map) {
      // Set CSS for the control border
      var controlUI = document.createElement("div");

      controlUI.style.marginBottom = "10px";
      controlDiv.appendChild(controlUI);

      // Set CSS for the control interior
      var controlText = document.createElement("img");
      controlText.src = "../zoom-in.svg";
      controlUI.appendChild(controlText);

      // Setup the click event listeners
      google.maps.event.addDomListener(controlUI, "click", function () {
        map.setZoom(map.getZoom() + 1);
      });

      // Set CSS for the control border
      var controlUILeft = document.createElement("div");
      controlDiv.appendChild(controlUILeft);

      // Set CSS for the control interior
      var controlTextLeft = document.createElement("img");
      controlTextLeft.src = "../zoom-out.svg";
      controlUILeft.appendChild(controlTextLeft);

      // Setup the click event listeners
      google.maps.event.addDomListener(controlUILeft, "click", function () {
        map.setZoom(map.getZoom() - 1);
      });
    }

    var customZoomInControlDiv = document.createElement("div");
    customZoomInControlDiv.id = "custom-zoom-controller-container";

    var customZoomInControl = new CustomZoomInControl(
      customZoomInControlDiv,
      map
    );

    customZoomInControlDiv.index = 1;
    map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(
      customZoomInControlDiv
    );

    const infoWindow = new google.maps.InfoWindow({
      content: "",
      className: "custom-info-window",
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
            infoWindow.setContent(`
                <div class="info-window">
                  <h3>Şu anda buradasınız</h3>
                </div>
              `);
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
    locationButton.innerHTML = `<img src="../find-me.svg" alt="find-me">`;
    locationButton.classList.add("custom-map-control-button");
    locationButton.id = "location-button";
    map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(locationButton);
    locationButton.addEventListener("click", centerToMyCurrentLocation);
    centerToMyCurrentLocation();

    // Marker icons located on public folder
    const VeganMarkerIcon = "../vegan-place.svg";
    const veganFriendlyMarkerIcon = "../vegan-friendly-place.svg";

    // Create markers for each location
    const markers = locations.map((position) => {
      let label = position.name;
      const marker = new google.maps.Marker({
        position: { lat: position.latitude, lng: position.longitude },
        icon: {
          url: position.vegan ? VeganMarkerIcon : veganFriendlyMarkerIcon,
          scaledSize: new google.maps.Size(50, 60),
        },
      });

      // Info window on click
      marker.addListener("click", () => {
        infoWindow.setContent(
          // Link to the place page
          label
            ? `
            <a href=${
              window.location.origin + "/places/" + position.id
            } class="info-window">
                <img src=${position.featured_image}
                  class="info-window-image"
                  alt=${label}>
                <div class="info-window-vegan-status">
                <h3>${label} <small>(${
                position.vegan ? "Vegan" : "Vegan Seçenekli"
              })</small>
                </h3>
                <p>${position.address}</p>
                </div>
                </a>
                `
            : ""
        );
        infoWindow.open(map, marker);
        map.setCenter(marker.getPosition());
      });
      return marker;
    });

    new MarkerClusterer({ markers, map });
  }
}
