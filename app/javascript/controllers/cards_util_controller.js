import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['card_frame']

  connect() {
    if (this.hasCard_frameTarget && document.body.dataset.actionName == 'index' ) {
      this.card_frameTarget.setAttribute("style", "width: 47%;")
    }
  }
}
