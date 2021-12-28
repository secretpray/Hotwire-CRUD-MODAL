import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['content']

  // Sets the popover offset using Stimulus data map objects.
  initialize() {
  }

  // Show the popover
  mouseOver() {
    this.contentTarget.classList.add('active')
  }
  // Hide the popover
  mouseOut() {
    this.contentTarget.classList.remove('active')
  }
}
