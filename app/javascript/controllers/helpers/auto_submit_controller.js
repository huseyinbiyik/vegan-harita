import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="helpers--auto-submit"
export default class extends Controller {
  static targets = ["form"];
  submit() {
    this.formTarget.requestSubmit();
  }
}
