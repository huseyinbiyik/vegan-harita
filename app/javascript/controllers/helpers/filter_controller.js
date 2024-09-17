import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="helpers--filter"
export default class extends Controller {
  static targets = ["input", "item"];
  filter(event) {
    event.preventDefault();  
    event.stopPropagation();
    const filterValue = this.inputTarget.value.toUpperCase();
    this.itemTargets.forEach((item) => {
      const textValue = item.textContent || item.innerText;
      if (textValue.toUpperCase().indexOf(filterValue) > -1) {
        item.style.display = "";
      } else {
        item.style.display = "none";
      }
    });
  }
}
