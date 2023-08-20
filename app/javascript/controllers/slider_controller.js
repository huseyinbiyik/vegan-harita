import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["image", "number"];

  initialize() {
    this.index = 0;
    this.showCurrentImage();
    console.log(this.imageTargets.length);
  }

  next() {
    if (this.index === this.imageTargets.length - 1) {
      this.index = -1;
    }
    this.index++;
    this.showCurrentImage();
  }

  previous() {
    if (this.index === 0) {
      this.index = this.imageTargets.length;
    }
    this.index--;
    this.showCurrentImage();
  }

  showCurrentImage() {
    this.updateSliderNumber();
    this.imageTargets.forEach((element, index) => {
      element.hidden = index !== this.index;
    });
  }

  updateSliderNumber() {
    this.numberTarget.innerText = `${this.index + 1} / ${
      this.imageTargets.length
    }`;
  }
}
