import { Controller } from "@hotwired/stimulus";

export default class PopupController extends Controller {
  static targets = ["options"];

  connect() {
    document.addEventListener("click", this.handleClickOutside.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this));
  }

  toggle() {
    this.optionsTarget.classList.toggle("hidden");
  }

  hide() {
    this.optionsTarget.classList.add("hidden");
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hide();
    }
  }
}