import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggleContent"];
  toggle() {
    this.toggleContentTarget.textContent =
      this.toggleContentTarget.textContent === "Düzenleme Öner"
        ? "Vazgeç"
        : "Düzenleme Öner";
    this.element.querySelectorAll(".edit-wrapper").forEach((element) => {
      if (element.hasAttribute("hidden")) {
        element.removeAttribute("hidden");
      } else {
        element.setAttribute("hidden", true);
      }
    });
  }
}
