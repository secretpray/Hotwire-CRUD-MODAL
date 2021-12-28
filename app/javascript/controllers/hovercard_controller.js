import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"];

  show() {
    if (this.hasCardTarget) {
      this.cardTarget.classList.remove("hidden");
    }
  }

  hide() {
    if (this.hasCardTarget) {
      this.cardTarget.classList.add("hidden");
    }
  }

  disconnect() {
    if (this.hasCardTarget) {
      this.cardTarget.remove();
    }
  }
}
