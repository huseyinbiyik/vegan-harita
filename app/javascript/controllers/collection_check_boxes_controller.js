import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="collection-check-boxes"
export default class extends Controller {
  static targets = ["checkboxItem", "checkboxes"];

  filter(event) {
    const filter = event.target.value.toLowerCase();
    this.checkboxItemTargets.forEach((item) => {
      const label = item.querySelector("label");
      const textValue = label.textContent || label.innerText;
      if (textValue.toLowerCase().indexOf(filter) > -1) {
        item.style.display = "";
      } else {
        item.style.display = "none";
      }
    });
  }
}
