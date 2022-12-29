import { Controller } from "@hotwired/stimulus";
import { MarkerClusterer } from "@googlemaps/markerclusterer";

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["map"];
  connect() {
    // Create the script tag, set the appropriate attributes
    var script = document.createElement("script");
    script.src =
      "https://maps.googleapis.com/maps/api/js?key=AIzaSyCd7rrq1f7qe3Ph6nN3FtArXTaSMIkFUQY&callback=initMap";
    script.async = true;

    // Attach your callback function to the `window` object
    window.initMap = function () {
      // JS API is loaded and available
      // The location of Kadikoy
      const kadikoy = { lat: 40.990335, lng: 29.029163 };
      // The map, centered at Kadikoy
      const map = new google.maps.Map(document.getElementById("map"), {
        zoom: 14,
        center: kadikoy,
      });
      // The marker, positioned at Kadikoy
      //   const marker = new google.maps.Marker({
      //     position: kadikoy,
      //     map: map,
      //   });
      // };

      const infoWindow = new google.maps.InfoWindow({
        content: "",
        disableAutoPan: true,
      });
      // Create an array of alphabetical characters used to label the markers.
      const labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      // Add some markers to the map.
      const markers = locations.map((position, i) => {
        const label = labels[i % labels.length];
        const marker = new google.maps.Marker({
          position,
          label,
        });

        // markers can only be keyboard focusable when they have click listeners
        // open info window when marker is clicked
        marker.addListener("click", () => {
          infoWindow.setContent(label);
          infoWindow.open(map, marker);
        });
        return marker;
      });

      // Add a marker clusterer to manage the markers.
      new MarkerClusterer({ markers, map });
    };

    const locations = JSON.parse(this.mapTarget.dataset.mapPlaces);


    // Append the 'script' element to 'head'
    document.head.appendChild(script);
  }
}
