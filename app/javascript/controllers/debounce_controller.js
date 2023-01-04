import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}
  static targets = ["form"];
  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit();
    }, 500);
  }
}
