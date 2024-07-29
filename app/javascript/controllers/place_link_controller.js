import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.toggleVisibility();
  }

  toggleVisibility() {
    if (window.location.pathname === "/") {
      this.element.classList.add("visible-link");
      this.element.classList.remove("invisible-link");
    } else {
      this.element.classList.add("invisible-link");
      this.element.classList.remove("visible-link");
    }
  }
}