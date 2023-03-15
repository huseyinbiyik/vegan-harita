import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { state: Boolean };
  static targets = ["menu"];

  toggle() {
    this.stateValue = !this.stateValue;

    if (this.stateValue) {
      this.openMenu();
      this.showCloseButton();
    } else {
      this.closeMenu();
      this.hideCloseButton();
    }
  }

  openMenu() {
    this.menuTarget.classList.remove("hidden");
  }

  closeMenu() {
    this.menuTarget.classList.add("hidden");
  }

  showCloseButton() {
    const closeButton = document.querySelector("#close-button");
    closeButton.classList.remove("hidden");
  }

  hideCloseButton() {
    const closeButton = document.querySelector("#close-button");
    closeButton.classList.add("hidden");
  }
}
