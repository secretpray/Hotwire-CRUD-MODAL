import { Controller } from "@hotwired/stimulus"

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
