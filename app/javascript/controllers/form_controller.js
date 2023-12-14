import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="form"
export default class extends Controller {
  static targets = ["frame"];

  hideFrame() {
    this.frameTarget.remove();
  }

  submitEnd(e) {
    if (e.detail.success) {
      this.hideFrame();
    }
  }

  resetForm() {
    this.frameTarget.reset();
  }
}
