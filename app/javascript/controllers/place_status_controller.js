import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="place-status"
export default class extends Controller {
  static targets = [
    "statusOpen",
    "statusClose",
    "noStatus",
    "openingHoursTable",
    "icon",
  ];
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
        if (openingHours === undefined) {
          this.noStatusTargets.forEach((element) => {
            element.removeAttribute("hidden");
          });

          this.iconTarget.classList.add("place-open-false");
        } else {
          this.openingHoursTableTarget.innerHTML +=
            openingHours.weekday_text.join("<br>");

          const openNow = place.opening_hours?.isOpen(new Date());

          if (openNow) {
            this.iconTarget.classList.add("place-open-true");
            this.statusOpenTargets.forEach((element) => {
              element.removeAttribute("hidden");
            });
          } else {
            this.iconTarget.classList.add("place-open-false");
            this.statusCloseTargets.forEach((element) => {
              element.removeAttribute("hidden");
            });
          }
        }
      }
    });
  }
}
