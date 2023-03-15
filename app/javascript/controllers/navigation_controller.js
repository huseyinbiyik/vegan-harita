import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { state: Boolean };
  static targets = ["menu"];

  toggle() {
    this.stateValue = !this.stateValue;

    if (this.stateValue) {
      this.openMenu();
      this.activateCloseButton();
    } else {
      this.closeMenu();
    }
  }

  openMenu() {
    this.menuTarget.classList.remove("hidden");
  }

  closeMenu() {
    this.menuTarget.classList.add("hidden");
  }

  activateCloseButton() {
    const closeButton = document.querySelector("#burger");
    closeButton.classList.remove("active");
  }
}
