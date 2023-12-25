import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="utils"
export default class extends Controller {
  static targets = ["preview", "uploadBtn"];
  static values = { assets: Array};

  uploadAvatar(e) {
    let reader = new FileReader();
    reader.onload = (e) => {
      this.previewTarget.src = e.target.result;
    };
    reader.readAsDataURL(e.target.files[0]);
  }
  uploadFiles (event) {
    const inputElement = event.target;
    if (inputElement.files.length > 0) {
      this.uploadBtnTarget.textContent = `${inputElement.files.length} ${this.assetsValue[0]}`;
    } else {
      this.uploadBtnTarget.textContent = `${this.assetsValue[1]}`;
    }
  }
}
