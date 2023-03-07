import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  toggle() {
    const searchWrapper = document.querySelector("#search-wrapper");
    const searchField = document.querySelector("#search-field");

    searchWrapper.classList.toggle("extend");
    searchField.focus();

    document.addEventListener("click", (e) => {
      if (
        e.target.id !== "search-wrapper" &&
        e.target.id !== "search-icon" &&
        e.target.id !== "search-field"
      ) {
        searchWrapper.classList.remove("extend");
      }
    });
  }
}
