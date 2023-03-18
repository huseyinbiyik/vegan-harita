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
      this.deactivateCloseButton();
    }
  }

  openMenu() {
    this.menuTarget.classList.add("active");
  }

  closeMenu() {
    this.menuTarget.classList.remove("active");
  }

  activateCloseButton() {
    const closeButton = document.querySelector("#burger");
    closeButton.classList.add("active");
  }

  deactivateCloseButton() {
    const closeButton = document.querySelector("#burger");
    closeButton.classList.remove("active");
  }
}
