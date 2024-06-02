import { Controller } from "@hotwired/stimulus";
import { MarkerClusterer } from "@googlemaps/markerclusterer";

export default class extends Controller {
  static targets = ["map"];
  static values = { assets: Array };
  connect() {
    if (typeof google != "undefined") {
      this.initializeMap();
    }
  }

  initializeMap() {
    this.createMap();
    this.createCustomMapControls();
    this.createMarkers();
    this.centerToMyCurrentLocation();
  }

  async fetchPlaces(bounds) {
    const response = await fetch(
      `/places.json?north=${bounds.getNorthEast().lat()}&south=${bounds
        .getSouthWest()
        .lat()}&east=${bounds.getNorthEast().lng()}&west=${bounds
        .getSouthWest()
        .lng()}`
    );
    const data = await response.json();
    this.places = data;
    return data;
  }

  createMap() {
    // Get user's last screen from local storage
    const mapLocation = JSON.parse(localStorage.getItem("mapLocation"));
    const latitude = mapLocation ? mapLocation.latitude : 40.990335;
    const longitude = mapLocation ? mapLocation.longitude : 29.029163;
    const zoom = mapLocation ? mapLocation.zoom : 14;

    this.map = new google.maps.Map(this.mapTarget, {
      mapId: "871933a16117d5a4",
      zoom: zoom,
      center: { lat: latitude, lng: longitude },
      disableDefaultUI: true,
      zoomControl: false,
      keyboardShortcuts: false,
    });

    const debouncedFetchAndCreateMarkers = this.debounce(async () => {
      const bounds = this.map.getBounds();
      await this.fetchPlaces(bounds);
      this.createMarkers();
    }, 800); // 800ms debounce

    this.map.addListener("bounds_changed", debouncedFetchAndCreateMarkers);
  }

  // Debounce function
  debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }

  createCustomMapControls() {
    // Icons in assets folder
    const ZoomInIcon = this.assetsValue[2];
    const ZoomOutIcon = this.assetsValue[3];

    function CustomZoomInControl(controlDiv, map) {
      var controlUI = document.createElement("div");
      controlUI.style.marginBottom = "10px";
      controlDiv.appendChild(controlUI);
      var controlText = document.createElement("img");
      controlText.src = ZoomInIcon;
      controlUI.appendChild(controlText);
      controlUI.addEventListener("click", function () {
        map.setZoom(map.getZoom() + 1);
      });
      var controlUILeft = document.createElement("div");
      controlUILeft.style.marginBottom = "45px";
      controlDiv.appendChild(controlUILeft);
      var controlTextLeft = document.createElement("img");
      controlTextLeft.src = ZoomOutIcon;
      controlUILeft.appendChild(controlTextLeft);
      controlUILeft.addEventListener("click", function () {
        map.setZoom(map.getZoom() - 1);
      });
    }

    var customZoomInControlDiv = document.createElement("div");
    customZoomInControlDiv.id = "custom-zoom-controller-container";

    var customZoomInControl = new CustomZoomInControl(
      customZoomInControlDiv,
      this.map
    );

    customZoomInControlDiv.index = 1;
    this.map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(
      customZoomInControlDiv
    );
  }

  getMyCurrentLocation() {
    if (this._myPosition === undefined) {
      this._myPosition = new Promise((resolve, reject) => {
        navigator.geolocation.getCurrentPosition(resolve, reject);
      });
    }
    return this._myPosition;
  }

  centerToMyCurrentLocation() {
    const infoWindow = new google.maps.InfoWindow({
      content: "",
      className: "custom-info-window",
      disableAutoPan: true,
    });


    const handleMyCurrentLocation = () => {
      locationButton.classList.add("loading");
      this.getMyCurrentLocation().then(
        (position) => {
          locationButton.classList.remove("loading");
          const pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };

          infoWindow.setPosition(pos);
          infoWindow.setContent(`
                <div class="info-window">
                  <p>${this.assetsValue[5]} ✋</p>
                </div>
              `);
          infoWindow.open(this.map);

          this.map.setCenter(pos);
          this.map.setZoom(16);
        },
        () => {
          locationButton.classList.remove("loading");
          handleLocationError(true, infoWindow, this.map.getCenter());
        }
      );
    };

    const handleLocationError = (browserHasGeolocation, infoWindow, pos) => {
      infoWindow.setPosition(pos);
      infoWindow.setContent(
        browserHasGeolocation
          ? `${this.assetsValue[6]}`
          : `${this.assetsValue[7]}`
      );
      infoWindow.open(this.map);
    };

    const locationButton = document.createElement("button");
    locationButton.innerHTML = `<img src="${this.assetsValue[4]}" alt="find-me">`;
    locationButton.classList.add("custom-map-control-button");
    locationButton.id = "location-button";
    this.map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(
      locationButton
    );
    locationButton.addEventListener("click", handleMyCurrentLocation);
  }

  async createMarkers() {
    const places = this.places;
    if (places) {
      const miniVeganIcon = this.assetsValue[11];

      // Info window
      const infoWindow = new google.maps.InfoWindow({
        content: "",
        className: "custom-info-window",
        disableAutoPan: true,
        maxWidth: 280,
        minWidth: 280,
      });

      // Create markers for each location
      const markers = places.map((place) => {
        let place_vegan = place.vegan;

        const placeMarker = document.createElement("div");
        placeMarker.className = `marker-container`;
        placeMarker.innerHTML = `
        ${ place_vegan ? '<img class="mini-vegan-icon" src="' + miniVeganIcon + '" alt="vegan-friendly">' : ""}
        <span class="marker-name">${place.name}</span>
        `

        let label = place.name;
        const marker = new google.maps.marker.AdvancedMarkerElement({
          position: { lat: place.latitude, lng: place.longitude },
          map: this.map,
          content: placeMarker,
        });

        // Info window on click
        marker.addListener("click", () => {
          const dummyDiv = document.createElement("div");
          const service = new google.maps.places.PlacesService(dummyDiv);
          const request = {
            placeId: place.place_id,
            fields: ["opening_hours", "utc_offset_minutes"],
          };

          service.getDetails(request, (requested_place, status) => {
            if (status === google.maps.places.PlacesServiceStatus.OK) {
              const checkOpeningHours = requested_place.opening_hours?.isOpen();
              const isOpen = checkOpeningHours
                ? `${this.assetsValue[8]}`
                : `${this.assetsValue[9]}`;
              infoWindow.setContent(
                label
                  ? `
            <div class="info-window">
            <a href=${window.location.origin + "/places/" + place.slug} >
            ${
              place.featured_image
                ? `<img src=${place.featured_image} class="info-window-image" alt=${label}>`
                : ""
            }

            <div>
              <div class="info-window-heading">
                <h3>${label}</h3>
                <div class="place-status place-open-${checkOpeningHours}">
                  <img src=${this.assetsValue[10]}>
                  <span class="status-text">${isOpen.toLowerCase()}</span>
                </div>
              </div>
              <p>${place.address}</p>
            </div>
            </a>
          </div>
            `
                  : ""
              );
              infoWindow.open(this.map, marker);
              this.map.setCenter(marker.getPosition());
            }
          });
        });

        return { marker, vegan: place_vegan };
      });

      // Cluster only non-vegan markers
      const nonVeganMarkers = markers.filter(({ vegan }) => !vegan).map(({ marker }) => marker);

      new MarkerClusterer({ markers: nonVeganMarkers, map: this.map });

      // Close info window on map click
      this.map.addListener("click", () => {
        infoWindow.close();
      });
    }
  }

  disconnect() {
    const center = this.map.getCenter();
    const latitude = center.lat();
    const longitude = center.lng();
    const zoom = this.map.getZoom();
    const mapLocation = { latitude, longitude, zoom };
    localStorage.setItem("mapLocation", JSON.stringify(mapLocation || {}));
  }
}
