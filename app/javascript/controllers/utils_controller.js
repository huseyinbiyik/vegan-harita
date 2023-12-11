import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="utils"
export default class extends Controller {
  static targets = ["preview"];
  uploadAvatar(e) {
    let reader = new FileReader();
    reader.onload = (e) => {
      this.previewTarget.src = e.target.result;
    };
    reader.readAsDataURL(e.target.files[0]);
  }
}
