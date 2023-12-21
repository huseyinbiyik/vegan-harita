import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="place-status"
export default class extends Controller {
  static targets = ["statusOpen", "statusClose", "openingHoursTable", "icon"];
  static values = { placeId: String };
  connect() {
    if (typeof google != "undefined") {
      this.getOpeningHours();
    }
  }

  async getOpeningHours() {
    const request = {
      placeId: this.placeIdValue,
      fields: ["opening_hours", "utc_offset_minutes"],
    };

    const dummyDiv = document.createElement("div");
    const service = new google.maps.places.PlacesService(dummyDiv);

    service.getDetails(request, (place, status) => {
      if (status === google.maps.places.PlacesServiceStatus.OK) {
        const openingHours = place.opening_hours;
        console.log(openingHours);

        this.openingHoursTableTarget.innerHTML +=
          openingHours.weekday_text.join("<br>");

        // Better to use both conditionals for low network connections and to avoid  misinformation instead of just default one
        if (openingHours.isOpen()) {
          this.iconTarget.classList.add("place-open");
          this.statusOpenTargets.forEach((element) => {
            element.removeAttribute("hidden");
          });
        } else {
          this.iconTarget.classList.add("place-closed");
          this.statusCloseTargets.forEach((element) => {
            element.removeAttribute("hidden");
          });
        }
      }
    });
  }
}
