import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['pagy', 'more', 'lite']
  // static get targets() { return [ "pagy" ] }
  connect() {
    this.liteTarget.classList.add('opacity-30')
  }

  pagyTargetConnected(element) {
    // console.log('Connected pagyTarget: ', this.pagyTarget)
    // console.log('Connected pagyTargets: ', this.pagyTargets)
  }
  pagyTargetDisconnected(element) {
    // console.log('Disconnected pagyTarget: ', this.pagyTarget)
  }

  // Show the popover
  mouseOver() {
    if (this.hasPagyTarget) {
      this.liteTarget.classList.add('hidden')
      this.moreTarget.classList.remove('hidden')
    }
  }
  // Hide the popover
  mouseOut() {
    // console.log('mouseOut hasPagyTarget: ', this.hasPagyTarget)
    if (this.hasPagyTarget) {
      this.moreTarget.classList.add('hidden')
      this.liteTarget.classList.remove('hidden')
    }
  }
}
