import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['wrapper', 'results']

  connect() {
    document.addEventListener('click', this.handleClickOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside.bind(this))
  }

  handleClickOutside(e) {
    if(!this.wrapperTarget.contains(e.target)) {
      this.resultsTarget.innerHTML = ''
    }
  }
}