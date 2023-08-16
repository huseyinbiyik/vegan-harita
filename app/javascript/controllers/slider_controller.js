import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["image"];

  initialize() {
    this.index = 0;
    this.showCurrentImage();
  }

  next() {
    if (this.index === this.imageTargets.length - 1) {
      this.index = 0;
    }
    this.index++;
    this.showCurrentImage();
  }

  previous() {
    if (this.index === 0) {
      this.index = this.imageTargets.length - 1;
    }
    this.index--;
    this.showCurrentImage();
  }

  showCurrentImage() {
    this.imageTargets.forEach((element, index) => {
      element.hidden = index !== this.index;
    });
  }
}
