import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["link"];

  connect() {
    this.updateLinkBehavior();
    window.addEventListener('resize', this.updateLinkBehavior.bind(this));
  }

  disconnect() {
    window.removeEventListener('resize', this.updateLinkBehavior.bind(this));
  }

  updateLinkBehavior() {
    if (window.innerWidth > 1023) {
      this.linkTarget.addEventListener('click', this.preventDefaultAction);
    } else {
      this.linkTarget.removeEventListener('click', this.preventDefaultAction);
    }
  }

  preventDefaultAction(event) {
    event.preventDefault();
  }
}