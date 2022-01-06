import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="service"
export default class extends Controller {
  static targets = [ 'userHistory' ]

  hideHistory() {
    this._hide()
  }

  _hide() {
    if (this.userHistoryTarget.classList.contains('active')) {
      this.userHistoryTarget.classList.remove('active')
    }
  }
}
