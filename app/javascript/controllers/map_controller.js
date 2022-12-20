import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="map"
export default class extends Controller {
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
      const marker = new google.maps.Marker({
        position: kadikoy,
        map: map,
      });
    };

    // Append the 'script' element to 'head'
    document.head.appendChild(script);
  }
}
