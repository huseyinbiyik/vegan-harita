import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="products--dependent-select"
export default class extends Controller {
  static targets = ["category"];

  select() {
    const categoryId = this.categoryTarget.value;
    const url = `/product_sub_categories?category_id=${categoryId}`;

    Turbo.visit(url, { frame: "product_sub_category" });
  }
}
