import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="place"
export default class extends Controller {
  connect() {
    // Create the script tag, set the appropriate attributes
    var script = document.createElement("script");
    script.src =
      "https://maps.googleapis.com/maps/api/js?key=AIzaSyCd7rrq1f7qe3Ph6nN3FtArXTaSMIkFUQY&libraries=places&callback=initAutocomplete";
    script.async = true;

    // Attach your callback function to the `window` object
    window.initAutocomplete = function () {
      // JS API is loaded and available
      let autocomplete;
      autocomplete = new google.maps.places.Autocomplete(
        document.getElementById("place_address"),
        {
          types: ["establishment"],
          componentRestrictions: { country: ["tr"] },
          fields: ["place_id", "geometry", "name", "formatted_address"],
        }
      );

      autocomplete.addListener("place_changed", onPlaceChanged);

      function onPlaceChanged() {
        var place = autocomplete.getPlace();
        if (place.geometry) {
          document.getElementById("place_latitude").value =
            place.geometry.location.lat();
          document.getElementById("place_longitude").value =
            place.geometry.location.lng();
        } else {
          document.getElementById("place_address").placeholder =
            "Enter a place";
        }
      }

      map = new google.maps.Map(document.getElementById("map"), {
        center: { lat: -34.397, lng: 150.644 },
        zoom: 8,
      });
    };

    // Append the 'script' element to 'head'
    document.head.appendChild(script);
  }
}
