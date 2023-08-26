import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const selectElement = this.element.querySelector('#tag-select');
    selectElement.multiple = true;
    selectElement.size = selectElement.length;
    for (const optionElement of selectElement.options) {
      optionElement.addEventListener('mousedown', this.selectTag.bind(this));
    }
  }

  selectTag(event) {
    event.preventDefault();
    const optionElement = event.target;
    optionElement.selected = !optionElement.selected;
  }
}
