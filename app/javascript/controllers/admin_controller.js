import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["source"];
  connect() {
    if (this.sourceTarget.children.length == 0) {
      this.sourceTarget.innerHTML = `
      <h2 style="text-align:center; margin-top:16px; font-weight:400;">Her Şey Tamam, Veganlığa Devam <br>🌈🐮🐷🐥☀️ </h2>
      `
    }
  }

  
}
