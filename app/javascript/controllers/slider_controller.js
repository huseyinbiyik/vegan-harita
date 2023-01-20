import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["image"];

  connect() {
    this.showCurrentImage();
  }

  next() {
    this.index++;
    if (this.index === this.imageTargets.length) {
      this.index = 0;
    }
    this.showCurrentImage();
  }

  previous() {
    this.index--;
    this.showCurrentImage();
  }

  showCurrentImage() {
    this.imageTargets.forEach((el, i) => {
      el.classList.toggle("slider__image--hidden", this.index !== i);
      el.classList.toggle("slider__image--current", this.index === i);
    });
  }

  get index() {
    return parseInt(this.data.get("index")) || 0;
  }

  set index(value) {
    this.data.set("index", value);
  }
}
