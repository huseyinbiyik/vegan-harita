import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggleContent"];
  static values = { button: Array };
  connect() {
    this.toggleContentTarget.textContent = this.buttonValue[0];
  }
  toggle() {
    if (this.toggleContentTarget.textContent == this.buttonValue[0]) {
      this.toggleContentTarget.textContent = this.buttonValue[1];
    } else {
      this.toggleContentTarget.textContent = this.buttonValue[0];
    }
    this.element.querySelectorAll(".edit-wrapper").forEach((element) => {
      if (element.hasAttribute("hidden")) {
        element.removeAttribute("hidden");
      } else {
        element.setAttribute("hidden", true);
      }
    });
  }
}
